class AddFieldsToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :github_username, :string
    add_column :users, :ssh_public_key, :text
  end
end
