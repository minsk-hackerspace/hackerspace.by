class AddBepaidFieldsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :bepaid_number, :integer
    add_column :users, :monthly_payment_amount, :float, default: 0
    add_column :users, :next_month_payment_amount, :float
    add_column :users, :next_month, :integer
    add_column :users, :current_debt, :float
  end
end
