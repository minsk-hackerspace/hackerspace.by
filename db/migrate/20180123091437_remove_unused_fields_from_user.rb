class RemoveUnusedFieldsFromUser < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :badge_comment
    remove_column :users, :monthly_payment_amount
    remove_column :users, :next_month_payment_amount
    remove_column :users, :next_month
    remove_column :users, :current_debt
  end
end
