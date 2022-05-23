# == Schema Information
#
# Table name: tariffs
#
#  id                 :integer          not null, primary key
#  ref_name           :string
#  name               :string
#  description        :string
#  access_allowed     :boolean
#  monthly_price      :decimal(, )
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  accessible_to_user :boolean          default(FALSE), not null
#
class Tariff < ApplicationRecord
  CHANGE_LIMIT_IN_DAYS = 30

  has_many :users

  scope :accessible_by_user, -> { where(accessible_to_user: true) }
  
  validates :monthly_price, numericality: {greater_than_or_equal_to: 0}

  def name_with_price
    "#{self.name} (#{self.monthly_price} BYN)"
  end

  def self.available_by(user)
    return all if user.admin?

    accessible_by_user
  end
end
