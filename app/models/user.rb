# == Schema Information
#
# Table name: users
#
#  id                        :integer          not null, primary key
#  email                     :string           default(""), not null
#  encrypted_password        :string           default(""), not null
#  reset_password_token      :string
#  reset_password_sent_at    :datetime
#  remember_created_at       :datetime
#  sign_in_count             :integer          default(0), not null
#  current_sign_in_at        :datetime
#  last_sign_in_at           :datetime
#  current_sign_in_ip        :string
#  last_sign_in_ip           :string
#  created_at                :datetime
#  updated_at                :datetime
#  hacker_comment            :string
#  badge_comment             :string
#  photo_file_name           :string
#  photo_content_type        :string
#  photo_file_size           :integer
#  photo_updated_at          :datetime
#  first_name                :string
#  last_name                 :string
#  bepaid_number             :integer
#  monthly_payment_amount    :float            default(0.0)
#  next_month_payment_amount :float
#  next_month                :integer
#  current_debt              :float
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

require 'bepaid.rb'

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, #:registerable,
         #:recoverable, :rememberable,
         :trackable
          # :validatable
  comma do
    id
    first_name
    last_name
    email
    hacker_comment
    badge_comment
    bepaid_number
    monthly_payment_amount
    next_month_payment_amount
    next_month
    current_debt
    sign_in_count
    last_sign_in_at
    created_at
    updated_at
  end

  ROLES = %w(hacker admin)

  has_many :projects

  has_many :roles, through: :users_roles
  has_many :users_roles
  has_many :erip_transactions

  has_attached_file :photo,
                    styles: {
                        original: '600x600>',
                        medium: '200x200#',
                        thumb: '60x60'
                    },
                    default_url: 'default_hacker_avatar_60x60.png'

  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\Z/
  validates_attachment :photo, size: { in: 0..3.megabytes }

  validates :email, presence: true, uniqueness: true, length: {maximum: 255}
  validates :monthly_payment_amount, numericality: { greater_than_or_equal_to: 0 }

  after_save :create_bepaid_bill

  def admin?
    check_role('admin')
  end

  def last_fee
    self.erip_transactions
        .where(status: 'successful', transaction_type: 'payment', purpose: 'fee')
        .order(paid_at: :desc).first
  end

  def payments
    self.erip_transactions
        .where(status: 'successful', transaction_type: 'payment')
        .order(paid_at: :desc)
  end

  def karma
    self.erip_transactions
        .where(status: 'successful', transaction_type: 'payment', purpose: 'donate')
        .where('paid_at > ?', -90.days.from_now)
        .sum(:amount)
  end

  private

  def check_role(role)
    self.roles.map(&:name).include? role
  end

  #TODO: maybe place this to concerns?
  def create_bepaid_bill
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
