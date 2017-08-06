class AddUserIdToEripTransaction < ActiveRecord::Migration[5.0]
  def change
    add_belongs_to :erip_transactions, :user
  end
end
