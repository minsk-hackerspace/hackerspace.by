class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.text :short_desc
      t.text :full_desc
      t.string :image

      t.timestamps
    end
  end
end
