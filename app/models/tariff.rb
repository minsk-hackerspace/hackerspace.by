class Tariff < ApplicationRecord
  has_many :users

  validates :monthly_price, numericality: {greater_than_or_equal_to: 0}

  def name_with_price
    "#{self.name} (#{self.monthly_price} BYN)"
  end
end
