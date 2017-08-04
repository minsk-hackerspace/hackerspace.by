class CreateBepaidSettings < ActiveRecord::Migration[5.0]
  def up
    Setting.create(key: 'bePaid_ID', value: '')
    Setting.create(key: 'bePaid_secret', value: '')
    Setting.create(key: 'bePaid_baseURL', value: 'https://api.bepaid.by')
    Setting.create(key: 'bePaid_serviceNo', value: '248')# ID of membership fee service
  end

  def down
    Setting.where(key: 'bePaid_ID').delete_all
    Setting.where(key: 'bePaid_secret').delete_all
    Setting.where(key: 'bePaid_baseURL').delete_all
    Setting.where(key: 'bePaid_serviceNo').delete_all

  end
end
