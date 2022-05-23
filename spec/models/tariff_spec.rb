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
require 'rails_helper'

RSpec.describe Tariff, type: :model do

  describe "tariff changes logic" do
    let(:user) { create :user }
    let(:admin) { create :admin_user }
    let(:tariff) { create :tariff } 
    let(:accessible_to_user_tariff) { create :tariff, accessible_to_user: true } 

    before do
      tariff
      accessible_to_user_tariff
    end

    it 'returns all for admin' do
      expect(Tariff.available_by(admin)).to eq(Tariff.all)
    end   

    it 'returns all accessible to user only' do
      expect(Tariff.available_by(user)).to eq([accessible_to_user_tariff])
    end   
  end
end
