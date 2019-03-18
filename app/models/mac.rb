# == Schema Information
#
# Table name: macs
#
#  id      :integer          not null, primary key
#  address :string
#  user_id :integer
#
# Indexes
#
#  index_macs_on_address  (address)
#  index_macs_on_user_id  (user_id)
#

class Mac < ApplicationRecord
  belongs_to :user
  validates_uniqueness_of :address
end
