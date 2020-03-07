# == Schema Information
#
# Table name: nfc_keys
#
#  id         :integer          not null, primary key
#  body       :string
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_nfc_keys_on_user_id  (user_id)
#

class NfcKey < ApplicationRecord
  belongs_to :user, required: true
  validates_uniqueness_of :body
end
