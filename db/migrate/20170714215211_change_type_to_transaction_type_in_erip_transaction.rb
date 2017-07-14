class ChangeTypeToTransactionTypeInEripTransaction < ActiveRecord::Migration[5.0]
  def change
    rename_column :erip_transactions, :type, :transaction_type
  end
end
