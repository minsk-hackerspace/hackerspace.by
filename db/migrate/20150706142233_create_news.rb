#encoding: UTF-8
class CreateNews < ActiveRecord::Migration
  def change
    create_table :news do |t|
      t.string :title
      t.text :short_desc
      t.text :description
      t.string :photo_file_name
      t.string :photo_content_type
      t.integer :photo_file_size
      t.datetime :photo_updated_at
      t.integer :user_id
      t.boolean :public
      t.string :markup_type

      t.timestamps
    end
  end
end
