require 'rails_helper'

describe ActiveUsersQuery do
  describe '.perform' do
    let!(:user_1) { create(:user, :with_payment) }
    let!(:user_2) { create(:user, :with_payment) }

    it 'returns deafult not epmpty users set' do
      expect(described_class.new(order: nil).perform).not_to be_empty
    end

    it 'returns last_seen not epmpty users set' do
      expect(described_class.new(order: 'last_seen').perform).not_to be_empty
    end
  end
end
