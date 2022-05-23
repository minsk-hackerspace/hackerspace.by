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
FactoryBot.define do
  factory :tariff do
    monthly_price { 0 } 
  end
end
