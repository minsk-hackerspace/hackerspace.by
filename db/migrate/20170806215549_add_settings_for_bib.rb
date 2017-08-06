class AddSettingsForBib < ActiveRecord::Migration[5.0]
  def up
    Setting.create(key: 'bib_baseURL', value: 'https://ibank.belinvestbank.by/', description: 'Bank API base URL')
    Setting.create(key: 'bib_login', value: '', description: 'Login for Belinvestbank')
    Setting.create(key: 'bib_password', value: '', description: 'Password for Belinvestbank')
  end

  def down
    Setting.where(key: 'bib_baseURL').delete_all
    Setting.where(key: 'bib_login').delete_all
    Setting.where(key: 'bib_password').delete_all
  end
end
