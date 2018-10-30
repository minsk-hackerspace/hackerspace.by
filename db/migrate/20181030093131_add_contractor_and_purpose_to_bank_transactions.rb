class AddContractorAndPurposeToBankTransactions < ActiveRecord::Migration[5.1]
  def change
    add_column :bank_transactions, :contractor, :string
    add_column :bank_transactions, :purpose, :string
  end
end
