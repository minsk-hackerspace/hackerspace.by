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
  validates :body, format: { with: /\A([0-9a-fA-F]{2}:){3,6}[0-9a-fA-F]{2}\z/,
                             message: "должен быть в формате xx:yy:zz:kk или xx:yy:zz:kk:nn:mm (четыре или семь байт)" }

  def to_s
    body
  end
end
