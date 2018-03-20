class AddAfishaColumnsToNews < ActiveRecord::Migration[4.2]
  def change
    add_column :news, :show_on_homepage, :boolean
    add_column :news, :show_on_homepage_till_date, :datetime
    add_column :news, :url, :string, default: nil
  end
end
