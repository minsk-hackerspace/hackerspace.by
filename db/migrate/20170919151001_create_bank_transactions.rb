class CreateBankTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :bank_transactions do |t|
      t.float :plus
      t.float :minus
      t.string :unp
      t.string :their_account
      t.string :our_account
      t.string :document_number

      t.timestamps index: true
    end
  end
end
