class AddUserTariffEditColumns < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :tariff_changed_at, :datetime
    add_column :tariffs, :accessible_to_user, :boolean, default: :false, null: false
  end
end
