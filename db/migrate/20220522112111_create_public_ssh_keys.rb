class CreatePublicSshKeys < ActiveRecord::Migration[7.0]
  def up
    create_table :public_ssh_keys do |t|
      t.text :body, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    if ActiveRecord::Base.connection.column_exists?(:users, :ssh_public_key)
      User.where.not(ssh_public_key: [nil, ""]).find_each do |user|
        user.public_ssh_keys.create(body: user.ssh_public_key)
      end

      remove_column :users, :ssh_public_key
    end
  end

  def down
    drop_table :public_ssh_keys
  end
end
