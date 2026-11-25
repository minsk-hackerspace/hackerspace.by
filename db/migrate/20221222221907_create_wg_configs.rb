class CreateWgConfigs < ActiveRecord::Migration[7.0]
  def up
    create_table :wg_configs do |t|
      t.string :name, null: false
      t.string :publickey, null: false

      t.belongs_to :user, foreign_key: true

      t.timestamps
    end

    say 'Run `rails wg_configs:ensure_settings wg_configs:generate_defaults` after installing WireGuard tools.'
  end

  def down
    drop_table :wg_configs
  end
end
