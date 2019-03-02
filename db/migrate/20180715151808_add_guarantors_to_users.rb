class AddGuarantorsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_belongs_to :users, :guarantor1
    add_belongs_to :users, :guarantor2
  end
end
