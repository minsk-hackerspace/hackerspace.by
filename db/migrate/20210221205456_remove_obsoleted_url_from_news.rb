class RemoveObsoletedUrlFromNews < ActiveRecord::Migration[6.0]
  def change
    remove_column :news, :url
  end
end
