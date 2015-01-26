# == Schema Information
#
# Table name: devices
#
#  id                 :integer          not null, primary key
#  name               :string(255)      not null
#  encrypted_password :string(255)      not null
#  created_at         :datetime
#  updated_at         :datetime
#

class Device < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable#, :registerable,
         #:recoverable, :rememberable, :trackable, :validatable
  has_many :events, dependent: :destroy

  validates :name, presence: true
end
