class BepaidDonations < ActiveRecord::Migration[5.0]
  def change
    add_column :erip_transactions, :purpose, :string
  end
end
