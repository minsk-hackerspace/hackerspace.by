class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #  protect_from_forgery with: :exception
  protect_from_forgery with: :null_session

  before_action :check_if_hs_open if Rails.env.production?
  before_action :check_for_present_people if Rails.env.production?
  before_action :check_for_hs_balance
  before_action :calc_kitty_number
  before_action :get_transactions

  rescue_from CanCan::AccessDenied do |exception|
    message = "Cannot #{exception.action} on #{exception.subject}"
    Rails.logger.error message
    redirect_to root_url, alert: message
  end

  def check_if_hs_open
    @event = Event.light.where('created_at >= ?', 30.minutes.ago).order(created_at: :desc).first

    @hs_open_status = if @event.nil?
                        Hspace::UNKNOWN
                      else
                        event_status
                      end
    # @hs_open_status = Hspace::OPENED
    # для отладки индикатора
  end

  def check_for_present_people
    d = Device.find_by(name: 'bob')
    @hs_present_people = d.events.where('created_at >= ?', 5.minutes.ago).map { |e| e.value }
    @hs_present_people.uniq!
  end

    def calc_kitty_number
    if user_signed_in?
        @hs_kitty_number = Rails.cache.fetch "hs_kitty_number", expires_in: 3.hours do
            three_months_ago_date = Time.now - 3.months
            transactions = BankTransaction.where('created_at > ?', three_months_ago_date)
            the_sum = transactions.sum(:minus)
            (100 * @hs_balance / the_sum).round(1)

        end
    end
    end

  def check_for_hs_balance
    if user_signed_in?
      @hs_balance = Rails.cache.fetch "hs_balance", expires_in: 3.hours do
        if Rails.env.development? or Rails.env.test? then
            7777
        else
            Belinvestbank.fetch_balance unless Rails.env.development? or Rails.env.test?
        end
      end
    end
  end

  def get_transactions
    if user_signed_in?
      Rails.cache.fetch "bank_transactions", expires_in: 24.hours do
        unless Rails.env.development? or Rails.env.test?
          begin
            BankTransaction.get_transactions
            Balance.where(state: 0).ids.each { |i| Balance.find(i).update(state: Balance.find(i-1).state) }
          rescue => e
            Rails.logger.error(e.message)
            Rails.logger.error(e.backtrace)
            flash[:alert] = 'Не получилось забрать данные из банка'
            nil
          end
        end
      end
    end
  end

  private
  def event_status
    @event.value == 'on' ? Hspace::OPENED : Hspace::CLOSED
  end
end
