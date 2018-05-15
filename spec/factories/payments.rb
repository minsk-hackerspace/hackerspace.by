# == Schema Information
#
# Table name: payments
#
#  id                  :integer          not null, primary key
#  user_id             :integer
#  erip_transaction_id :integer
#  paid_at             :datetime         not null
#  amount              :decimal(, )      default(0.0), not null
#  start_date          :date
#  end_date            :date
#  payment_type        :string           not null
#  payment_form        :string           not null
#  description         :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  project_id          :integer
#
# Indexes
#
#  index_payments_on_erip_transaction_id  (erip_transaction_id)
#  index_payments_on_project_id           (project_id)
#  index_payments_on_user_id              (user_id)
#

FactoryGirl.define do
  factory :payment do
    paid_at DateTime.parse('21-04-2018 11:43:00 +03:00').utc
    amount 50
    payment_type 'membership'
    payment_form 'erip'
    start_date Date.parse('21-04-2018')
    end_date Date.parse('21-05-2018')
  end
end
