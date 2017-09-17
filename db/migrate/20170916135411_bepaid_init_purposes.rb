class BepaidInitPurposes < ActiveRecord::Migration[5.0]
  def up
    Setting.create(key: 'bePaid_donationNo', value: '249') # ID of donation service

    EripTransaction.where('erip LIKE \'%"service_no":248%\'').update(purpose: 'fee')
    EripTransaction.where('erip LIKE \'%"service_no":249%\'').update(purpose: 'donate')
    EripTransaction.where(purpose: nil).update(purpose: 'unclassified')
  end

  def down
    Setting.where(key: 'bePaid_donationNo').delete_all
  end
end
