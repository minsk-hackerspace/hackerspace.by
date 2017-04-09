# == Schema Information
#
# Table name: erip_transactions
#
#  id                     :integer          not null, primary key
#  status                 :string
#  message                :string
#  type                   :string
#  transaction_id         :string
#  uid                    :string
#  order_id               :string
#  amount                 :decimal(, )
#  currency               :string
#  description            :string
#  tracking_id            :string
#  transaction_created_at :datetime
#  expired_at             :datetime
#  paid_at                :datetime
#  test                   :boolean
#  payment_method_type    :string
#  billing_address        :json
#  customer               :json
#  payment                :json
#  erip                   :json
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class EripTransaction < ApplicationRecord
end
