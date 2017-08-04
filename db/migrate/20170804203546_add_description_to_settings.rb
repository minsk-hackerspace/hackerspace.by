class AddDescriptionToSettings < ActiveRecord::Migration[5.0]
  def up
    add_column :settings, :description, :string
    Setting.where(key: 'bePaid_ID').update(description: 'ID магазина из личного кабинета bePaid')
    Setting.where(key: 'bePaid_secret').update(description: 'Секретный ключ из личного кабинета bePaid')
    Setting.where(key: 'bePaid_serviceNo').update(description: 'Номер услуги в bePaid для членских взносов')
    Setting.where(key: 'bePaid_baseURL').update(description: 'Базовый адрес для запросов к API bePaid')
  end

  def down
    remove_column :settings, :description
  end
end
