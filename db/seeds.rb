unless Rails.env.production?
  Project.destroy_all
  User.destroy_all

  User.create(email: 'developer@hackerspace.by', password: '111111')
  User.create(email: 'developer2@hackerspace.by', password: '111111')

  7.times do
    Project.create!(name: Faker::Commerce.product_name,
                    short_desc: Faker::Lorem.paragraph(rand(2..4)),
                    full_desc: Faker::Lorem.paragraph(rand(7..20)),
                    user: User.all.sample,
                    photo: File.open(Dir['public/images/*.jpg'].sample))
  end
end
