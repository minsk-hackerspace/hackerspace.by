class CreateProjects < ActiveRecord::Migration[4.2]
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
