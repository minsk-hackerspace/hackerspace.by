# == Schema Information
#
# Table name: bank_transactions
#
#  id              :integer          not null, primary key
#  contractor      :string
#  document_number :string
#  irregular       :boolean          default(FALSE)
#  minus           :float
#  note            :string
#  our_account     :string
#  plus            :float
#  purpose         :string
#  their_account   :string
#  unp             :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_bank_transactions_on_created_at  (created_at)
#  index_bank_transactions_on_updated_at  (updated_at)
#
FactoryBot.define do
  factory :bank_transaction do
    plus { 0.0 }
    minus { 2340.0 }
    unp { "unp" }
    their_account { "000" }
    our_account { "111" }
    document_number { "1234" }
    # their_account { "BY00UNBS00000000000000000000" }
    # our_account { "BY50BLBB30150102386174001001" }
    irregular { false }
    note { "Test transaction" }
    contractor { "Test Contractor" }
    purpose { "Test Purpose" }
  end
end
