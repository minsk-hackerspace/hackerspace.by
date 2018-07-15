class AddNoteToBankTransactions < ActiveRecord::Migration[5.1]
  def change
    add_column :bank_transactions, :note, :string
  end
end
