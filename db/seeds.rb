# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Project.destroy_all

unless Rails.env.production?
  7.times do
    Project.create(name: Faker::Commerce.product_name, short_desc: Faker::Lorem.paragraph(rand(2..4)), full_desc: Faker::Lorem.paragraph(rand(7..20)))
  end
end
