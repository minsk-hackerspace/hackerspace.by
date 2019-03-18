class AddTelegramAndBobFieldsToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :telegram_username, :string
    add_column :users, :alice_greeting, :string
    add_column :users, :last_seen_in_hackerspace, :datetime
    add_column :users, :account_suspended, :boolean
    add_column :users, :account_banned, :boolean
  end
end
