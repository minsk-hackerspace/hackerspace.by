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
require 'rails_helper'

RSpec.describe PublicSshKey, type: :model do
  describe "relations and validations" do
    let(:ssh_key_valid1) { build :public_ssh_key }
    let(:ssh_key_valid2) { build :public_ssh_key, :without_email }
    let(:ssh_key_invalid_body) { build :public_ssh_key, body: 'dwqdqdqdwqwdqwd' }
    let(:ssh_key_empty_body) { build :public_ssh_key, body: nil }
    let(:ssh_key_invalid_type) { build :public_ssh_key, :invalid_type }
    let(:ssh_key_invalid_format) { build :public_ssh_key, :invalid_format }
    let(:ssh_key_with_options) { build :public_ssh_key, :with_options }
    let(:ssh_key_without_user) { build :public_ssh_key, user: nil }

    it 'should validate SSH key format' do
      ssh_key_invalid_type.validate
      expect(ssh_key_invalid_type.errors[:key]).not_to be_empty

      ssh_key_invalid_format.validate
      expect(ssh_key_invalid_format.errors[:key]).not_to be_empty

      ssh_key_with_options.validate
      expect(ssh_key_with_options.errors[:key]).not_to be_empty

      ssh_key_valid1.validate
      expect(ssh_key_valid1.errors[:key]).to be_empty

      ssh_key_valid2.validate
      expect(ssh_key_valid2.errors[:key]).to be_empty

      ssh_key_invalid_body.validate
      expect(ssh_key_invalid_body.errors[:key]).not_to be_empty

      expect(ssh_key_empty_body.valid?).to be false
    end

    it 'returns true if valid' do
      expect(ssh_key_valid1.valid?).to be true
    end

    it 'should validate user with errors' do
      ssh_key_without_user.valid?
      expect(ssh_key_without_user.errors[:user]).not_to be_empty
    end

    it 'should not be valid wihtout user' do
      expect(ssh_key_without_user.valid?).to be false
    end
  end
end
