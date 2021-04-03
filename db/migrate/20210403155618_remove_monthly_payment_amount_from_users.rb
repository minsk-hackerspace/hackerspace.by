class RemoveMonthlyPaymentAmountFromUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :monthly_payment_amount
  end
end
