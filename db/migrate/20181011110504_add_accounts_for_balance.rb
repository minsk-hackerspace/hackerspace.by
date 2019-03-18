class AddAccountsForBalance < ActiveRecord::Migration[5.1]
  def up
    Setting.create(key: 'bib_balanceAccounts', value: 'BY93BLBB30150102386174001003 BY50BLBB30150102386174001001 BY57BLBB31350102386174001001')
  end

  def down
    Settings.where(key: 'bib_balanceAccounts').delete_all
  end
end
