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

  def admin?
    check_role('admin')
  end

  private

  def check_role(role)
    self.roles.map(&:name).include? role
  end
end
