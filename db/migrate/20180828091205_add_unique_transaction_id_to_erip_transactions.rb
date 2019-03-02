class AddUniqueTransactionIdToEripTransactions < ActiveRecord::Migration[5.1]
  def change
    add_index :erip_transactions, :transaction_id, unique: true
  end
end
