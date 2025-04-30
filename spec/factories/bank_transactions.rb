FactoryBot.define do
  factory :bank_transaction do
    plus { 0.0 }
    minus { 2340.0 }
    unp { "unp" }
    their_account { "000" }
    our_account { "111" }
    document_number { "1234" }
  end
end
