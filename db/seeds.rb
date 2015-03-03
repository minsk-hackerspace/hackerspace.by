unless Rails.env.production?
  Project.destroy_all
  User.destroy_all
  Device.destroy_all
  Event.destroy_all

  User.create(email: 'developer@hackerspace.by', password: '111111')
  User.create(email: 'developer2@hackerspace.by', password: '111111')

  7.times do
    Project.create!(name: Faker::Commerce.product_name,
                    short_desc: Faker::Lorem.paragraph(rand(2..4)),
                    full_desc: Faker::Lorem.paragraph(rand(7..20)),
                    user: User.all.sample,
                    photo: File.open(Dir['public/images/*.jpg'].sample))
  end

  Device.create(name: 'device1', password: '111111')
  Device.create(name: 'device2', password: '111111')

  22.times do
    Event.create(event_type: 'light', value: ['on', 'off'].sample, device: Device.all.sample)
  end
end
