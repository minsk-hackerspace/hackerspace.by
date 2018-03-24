class CreateThanks < ActiveRecord::Migration[5.1]
  def change
    create_table :thanks do |t|
      t.string "name"
      t.text "short_desc"
      t.text "full_desc"
      t.string "image"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string "photo_file_name"
      t.string "photo_content_type"
      t.integer "photo_file_size"
      t.datetime "photo_updated_at"
      t.integer "user_id"
      t.string "markup_type", default: "html"
      t.boolean "public", default: false

      t.index ["user_id"]
      t.timestamps
    end
  end
end
