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
#  purpose                :string
#
# Indexes
#
#  index_erip_transactions_on_user_id  (user_id)
#

class EripTransaction < ApplicationRecord
  belongs_to :user
  serialize :billing_address, JSON
  serialize :customer, JSON
  serialize :payment, JSON
  serialize :erip, JSON
end
