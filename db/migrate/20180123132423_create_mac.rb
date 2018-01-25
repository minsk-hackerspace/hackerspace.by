class CreateMac < ActiveRecord::Migration[5.0]
  def change
    create_table :macs do |t|
      t.string :address
      t.belongs_to :user
    end

    add_index :macs, :address
  end
end
