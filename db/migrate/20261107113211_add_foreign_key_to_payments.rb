class AddForeignKeyToPayments < ActiveRecord::Migration[8.1]
  def change
    add_foreign_key :payments, :users
  end
end
