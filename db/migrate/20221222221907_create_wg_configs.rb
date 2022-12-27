class CreateWgConfigs < ActiveRecord::Migration[7.0]
  def up
    create_table :wg_configs do |t|
      t.string :name, null: false
      t.string :privatekey, null: false
      t.string :publickey, null: false

      t.belongs_to :user, foreign_key: true

      t.timestamps
    end

    Setting.create(key: 'wgServerEndpoint',
                   description: 'WireGuard server endpoint (in format <IP>:<port>)',
                   value: 'localhost:1234')

    Setting.create(key: 'wgServerPublicKey',
                   description: 'WireGuard server public key',
                   value: '')

    Setting.create(key: 'wgFirstClientAddress',
                   description: 'WireGuard first client address',
                   value: '10.129.0.2')

    Setting.create(key: 'wgLastClientAddress',
                   description: 'WireGuard last client address',
                   value: '10.129.255.254')

    Setting.create(key: 'wgNetmask',
                   description: 'WireGuard netmask for virtual network',
                   value: '255.255.0.0')

    Setting.create(key: 'wgAllowedIPs',
                   description: 'WireGuard AllowedIPs client configuration parameter',
                   value: '10.129.0.0/16, 192.168.128.0/24')

    User.all.each do |user|
      WgConfig.create(name: 'default', user: user)
    end
  end

  def down
    Setting.where(key: 'wgServerEndpoint').delete_all
    Setting.where(key: 'wgServerPublicKey').delete_all
    Setting.where(key: 'wgFirstClientAddress').delete_all
    Setting.where(key: 'wgLastClientAddress').delete_all
    Setting.where(key: 'wgNetmask').delete_all
    Setting.where(key: 'wgAllowedIPs').delete_all

    drop_table :wg_configs
  end
end
