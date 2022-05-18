# == Schema Information
#
# Table name: users
#
#  id                       :integer          not null, primary key
#  email                    :string           default(""), not null
#  encrypted_password       :string           default(""), not null
#  reset_password_token     :string
#  reset_password_sent_at   :datetime
#  remember_created_at      :datetime
#  sign_in_count            :integer          default(0), not null
#  current_sign_in_at       :datetime
#  last_sign_in_at          :datetime
#  current_sign_in_ip       :string
#  last_sign_in_ip          :string
#  created_at               :datetime
#  updated_at               :datetime
#  hacker_comment           :string
#  photo_file_name          :string
#  photo_content_type       :string
#  photo_file_size          :integer
#  photo_updated_at         :datetime
#  first_name               :string
#  last_name                :string
#  bepaid_number            :integer
#  telegram_username        :string
#  alice_greeting           :string
#  last_seen_in_hackerspace :datetime
#  account_suspended        :boolean
#  account_banned           :boolean
#  monthly_payment_amount   :float            default(50.0)
#  github_username          :string
#  ssh_public_key           :text
#  is_learner               :boolean          default(FALSE)
#  project_id               :integer
#  guarantor1_id            :integer
#  guarantor2_id            :integer
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_guarantor1_id         (guarantor1_id)
#  index_users_on_guarantor2_id         (guarantor2_id)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

require 'bepaid.rb'
require 'digest/md5'

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable,
         :trackable

  comma do
    id
    first_name
    last_name
    email
    hacker_comment
    bepaid_number
    monthly_payment_amount
    sign_in_count
    last_sign_in_at
    created_at
    last_seen_in_hackerspace
    telegram_username
    alice_greeting
    account_suspended
    account_banned
    github_username
    is_learner
    guarantor1
    guarantor2
    paid_until
  end

  comma(:with_nfc) do
    id
    first_name
    last_name
    email
    hacker_comment
    bepaid_number
    monthly_payment_amount
    sign_in_count
    last_sign_in_at
    created_at
    last_seen_in_hackerspace
    telegram_username
    alice_greeting
    account_suspended
    account_banned
    github_username
    is_learner
    guarantor1
    guarantor2
    paid_until
    nfc_keys { |keys| keys.join(" ") }
  end

  ROLES = %w(hacker admin device)

  has_many :projects
  has_many :macs
  has_many :users_roles
  has_many :roles, through: :users_roles
  has_many :erip_transactions
  has_many :payments
  has_many :nfc_keys
  belongs_to :tariff
  belongs_to :guarantor1, class_name: 'User', optional: true
  belongs_to :guarantor2, class_name: 'User', optional: true

  has_attached_file :photo,
                    styles: {
                        original: '600x600>',
                        medium: '200x200#',
                        thumb: '60x60'
                    },
                    default_url: 'default_hacker_avatar_60x60.png'

  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\Z/
  validates_attachment :photo
  #, size: { in: 0..3.megabytes }

  validates :email, presence: true, uniqueness: true, length: {maximum: 255}
  validate :validate_guarantors
  validate :validate_ssh_key

  scope :signed_in, -> { where.not(last_sign_in_at: nil) }
  scope :paid, -> { where(id: Payment.user_ids) }
  scope :allowed, -> { where(account_suspended: [false, nil]).where(account_banned: [false, nil]) }

  scope :banned, -> { where(account_banned: true)}
  scope :not_banned, -> { where(account_banned: false)}
  scope :suspended, -> { where(account_suspended: true)}
  scope :not_suspended, -> { where(account_suspended: false)}
  scope :suspended_today, -> { where(account_suspended: true)
                              .where('suspended_changed_at > ?', Time.now - 1.day) }

  after_save :create_bepaid_bill, :set_as_suspended
  before_save :set_tariff_changed_at
  before_validation :normalize_tg_nickname

  validate :tariff_changes, on: :update

  attr_accessor :updating_by

  def self.active
    (allowed.paid + allowed.signed_in).uniq
  end

  # Return all users with fee expires after provided duration
  #
  # to be optimized, move logic to DB query
  def self.fee_expires_in(duration)
    User.active.select do |user|
      user.last_payment.present? ? user.paid_until < Date.today + duration : true
    end
  end

  def self.with_debt
    fee_expires_in(0.days)
  end

  def admin?
    check_role('admin')
  end

  def device?
    check_role('device')
  end

  def last_payment
    payments.order(paid_at: :desc).first
  end

  def first_payment_after_last_suspend
    payments.where('start_date >= ?', suspended_changed_at.to_date).order(start_date: :asc).first
  end


  # last day with valid payment for this user
  def paid_until
    last_payment&.end_date
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def full_name_with_id
    "#{self.id}. #{self.first_name} #{self.last_name}"
  end

  def full_name_with_id_tg
    tg = telegram_username.blank? ? "" : " @#{telegram_username}"
    "#{self.id}. #{self.first_name} #{self.last_name}" + tg
  end

  def avatar_url(style)
    if self.photo?
      self.photo.url(style)
    else
      hash = Digest::MD5.hexdigest(self.email.to_s.downcase)
      geometry = User.new.photo.styles[style].try(:geometry)
      size = geometry ? geometry.split('x').first : ''

      "https://gravatar.com/avatar/#{hash}?d=robohash&size=#{size}"
    end
  end

  def monthly_payment_amount
    s = self.tariff&.monthly_price
    s.nil? ? 0 : s
  end

  def expected_payment_amount
    unpaid_days_amount = (Date.today - paid_until).to_i
    missing_payment_amount = if unpaid_days_amount < 14
      (monthly_payment_amount * unpaid_days_amount.to_f / 30).ceil(2)
    else
      0
    end
    missing_payment_amount + monthly_payment_amount
  end

  def inactive?
    account_suspended? || account_banned?
  end

  def active?
    !inactive?
  end

  def access_allowed?
    active? && self.tariff&.access_allowed
  end

  def set_as_suspended
    never_paid = last_payment.nil? && (created_at < Time.now - 1.day)

    if active? && ((last_payment &&
        (last_payment.end_date < Date.today)) || never_paid)

      suspend!
    end
  end

  def suspend!
    return if account_suspended?

    transaction do
      #simple update without callbacks
      update_columns(account_suspended: true, suspended_changed_at: Time.now)
    end

    NotificationsMailer.with(user: self).notify_about_suspend.deliver_now
  end

  def unsuspend!
    return unless account_suspended?

    transaction do
      #simple update without callbacks
      update_columns(account_suspended: false, suspended_changed_at: Time.now)
    end

    # TODO move this to another methods/classes, one method - one action
    NotificationsMailer.with(user: self).notify_about_unsuspend.deliver_now

    begin
      tg = TelegramNotifier.new
      t = telegram_username.blank? ? "" : " @#{telegram_username}"
      m = "Участник №#{id} (#{full_name}#{t}) снова с нами! Оплачено по #{paid_until}."
      tg.send_message_to_all(m)
    rescue
      Rails.logger.warn "Telegram notification failed"
    end
  end

  def generate_tg_auth_token!
    return tg_auth_token if tg_auth_token.present? and Time.now < tg_auth_token_expiry

    self.update(tg_auth_token:  SecureRandom.alphanumeric(20), tg_auth_token_expiry: Time.now + 1.day)
    tg_auth_token
  end

  def self.find_by_auth_token(token)
    self.where(tg_auth_token: token).where('tg_auth_token_expiry > ?', Time.now).first
  end

  def able_to_change_tariff_now?
    return true if tariff_changed_at.nil? || admin?

    next_tariff_change_date <= Time.now
  end

  def tariff_changeble_date
    return Time.now if tariff_changed_at.nil?

    next_tariff_change_date
  end

  private

  def normalize_tg_nickname
    telegram_username.delete_prefix!('@') unless telegram_username.blank?
  end

  def validate_guarantors
    errors.add(:guarantor1_id, "is invalid") if self.guarantor1_id.present? and self.guarantor1_id == self.id
    errors.add(:guarantor2_id, "is invalid") if self.guarantor2_id.present? and self.guarantor2_id == self.id
    errors.add(:guarantor1_id, "shouldn't be same as Guarantor2") if self.guarantor1_id.present? and self.guarantor1_id == self.guarantor2_id
  end

  SSH_KEY_TYPES = %w(
    sk-ecdsa-sha2-nistp256@openssh.com ecdsa-sha2-nistp256 ecdsa-sha2-nistp384
    ecdsa-sha2-nistp521 sk-ssh-ed25519@openssh.com ssh-ed25519 ssh-dss ssh-rsa
  )

  def validate_ssh_key
    return unless ssh_public_key.present?

    key_type, key, comment = ssh_public_key.split(/\s+/, 3)
    key_is_base64 = (Base64.strict_encode64(Base64.decode64(key)) == key)
    errors.add(:ssh_public_key, "has invalid key type or garbage at the beginning") unless SSH_KEY_TYPES.include?(key_type)
    errors.add(:ssh_public_key, "has invalid format") if key_type.nil? || key.nil? || !key_is_base64
  end

  def tariff_changes
    return if admin? || updating_by.nil? || updating_by.admin?

    if tariff_id_changed? && tariff_changed_at && next_tariff_change_date > Time.now
      errors.add(:tariff, "You able change tariff once per #{Tariff::CHANGE_LIMIT_IN_DAYS} days.")
    end
  end

  def next_tariff_change_date
    (tariff_changed_at + Tariff::CHANGE_LIMIT_IN_DAYS.days)
  end

  def set_tariff_changed_at
    self.tariff_changed_at = Time.now if tariff_id_changed?
  end

  def check_role(role)
    self.roles.map(&:name).include? role
  end

  def self.paid_within_period(start_date, end_date)
    Rails.cache.fetch [start_date, end_date, :paid_within_period] do
      left_outer_joins(:payments).where(payments: {start_date: [Time.at(0)..end_date], end_date: [start_date..Date::Infinity.new]}).distinct
    end
  end

  def self.get_paid_users_graph(start_date, end_date)
    Rails.cache.fetch [start_date, end_date, :get_paid_users_graph] do
      graph = []
      start_date = start_date.beginning_of_month
      end_date = end_date.end_of_month
      dates = (start_date..end_date).to_a.select {|d| d == d.beginning_of_month}
      dates << end_date unless dates.include? end_date


      dates.each_index do |i|
        graph << [dates[i], self.paid_within_period(dates[i], dates[i+1]).group(:id).count.count] unless i >= dates.size - 1
      end
      graph
    end
  end

  #TODO: maybe place this to concerns?
  def create_bepaid_bill
    # Don't touch real web services during of test database initialization
    return if Rails.env.test?

    user = self

    bp = BePaid::BePaid.new Setting['bePaid_baseURL'], Setting['bePaid_ID'], Setting['bePaid_secret']

    amount = user.monthly_payment_amount

    #amount is (amoint in BYN)*100
    bill = {
      request: {
        amount: (amount * 100).to_i,
        currency: 'BYN',
        description: 'Членский взнос',
        email: 'jekhor@gmail.com',
        notification_url: 'https://hackerspace.by/admin/erip_transactions/bepaid_notify',
        ip: '127.0.0.1',
        order_id: '4444',
        customer: {
          first_name: 'Cool',
          last_name: 'Hacker',
        },
        payment_method: {
          type: 'erip',
          account_number: 444,
          permanent: 'true',
          editable_amount: 'true',
          service_no: Setting['bePaid_serviceNo'],
        }
      }
    }
    req = bill[:request]
    req[:email] = user.email
    req[:order_id] = user.id
    req[:customer][:first_name] = user.first_name
    req[:customer][:last_name] = user.last_name
    req[:payment_method][:account_number] = user.id

    begin
      res = bp.post_bill bill
      logger.debug JSON.pretty_generate res
    rescue  => e
      logger.error e.message
      logger.error e.http_body if e.respond_to? :http_body
      user.errors.add :base, "Не удалось создать счёт в bePaid, проверьте лог"
    end
  end
end
