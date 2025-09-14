require 'rails_helper'

describe SuspendUsersService do
  let(:service) { described_class.new }

  describe 'debitors attribute' do
    it 'returns empty list without raising errors' do
      expect(service.debitors).to eq nil
    end
  end

  describe '.set_users_as_suspended' do
    it 'returns [] without raising errors' do
      expect(service.set_users_as_suspended).to eq []
    end
  end
end
