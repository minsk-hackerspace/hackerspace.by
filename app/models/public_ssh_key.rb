# frozen_string_literal: true

# == Schema Information
#
# Table name: public_ssh_keys
#
#  id         :integer          not null, primary key
#  body       :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer          not null
#
# Indexes
#
#  index_public_ssh_keys_on_user_id  (user_id)
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#
class PublicSshKey < ApplicationRecord
  SSH_KEY_TYPES = %w[
    sk-ecdsa-sha2-nistp256@openssh.com ecdsa-sha2-nistp256 ecdsa-sha2-nistp384
    ecdsa-sha2-nistp521 sk-ssh-ed25519@openssh.com ssh-ed25519 ssh-dss ssh-rsa
  ].freeze

  belongs_to :user

  validates :body, presence: true
  validate :validate_ssh_key

  private

  def validate_ssh_key
    return unless body.present?

    key_type, key, = body.split(/\s+/, 3)
    if key_type.nil? || key.nil?
      errors.add(:key, 'has invalid format')
      return
    end
    key_is_base64 = (Base64.strict_encode64(Base64.decode64(key)) == key)
    errors.add(:key, 'has invalid key type or garbage at the beginning') unless SSH_KEY_TYPES.include?(key_type)
    errors.add(:key, 'has invalid format') unless key_is_base64
  end
end
