# == Schema Information
#
# Table name: erip_transactions
#
#  id                     :integer          not null, primary key
#  status                 :string
#  message                :string
#  transaction_type       :string
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
#  billing_address        :string
#  customer               :string
#  payment                :string
#  erip                   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  user_id                :integer
#
# Indexes
#
#  index_erip_transactions_on_transaction_id  (transaction_id) UNIQUE
#  index_erip_transactions_on_user_id         (user_id)
#

require 'rails_helper'

RSpec.describe EripTransaction, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
