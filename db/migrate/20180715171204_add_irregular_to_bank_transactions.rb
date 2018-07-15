class AddIrregularToBankTransactions < ActiveRecord::Migration[5.1]
  def change
    add_column :bank_transactions, :irregular, :boolean, default: false
  end
end
