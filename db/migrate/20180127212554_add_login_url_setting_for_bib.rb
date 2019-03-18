class AddLoginUrlSettingForBib < ActiveRecord::Migration[5.0]
  def up
    Setting.create(key: 'bib_loginBaseURL', value: 'https://login.belinvestbank.by/', description: 'Bank API base URL for login')
  end

  def down
    Setting.where(key: 'bib_loginBaseURL').delete_all
  end
end
