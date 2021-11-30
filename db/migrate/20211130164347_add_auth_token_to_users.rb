class AddAuthTokenToUsers < ActiveRecord::Migration[6.1]
  def up
    add_column :users, :tg_auth_token, :string
    add_column :users, :tg_auth_token_expiry, :datetime

    Setting.create(key: 'bramnikBotName', value: 'BramnikBot', description: 'Name of the Bramnik Telegram bot')
  end

  def down
    remove_column :users, :tg_auth_token
    remove_column :users, :tg_auth_token_expiry
  end
end
