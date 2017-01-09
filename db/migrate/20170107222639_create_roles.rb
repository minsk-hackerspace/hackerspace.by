class CreateRoles < ActiveRecord::Migration[5.0]
  def change
    create_table :roles do |t|
      t.string :name, null: false

      t.timestamps
    end

    create_table :users_roles, id: false do |t|
      t.belongs_to :user, index: true, null: false
      t.belongs_to :role, index: true, null: false
    end

    add_index :users_roles, [:user_id, :role_id], unique: true
  end
end
