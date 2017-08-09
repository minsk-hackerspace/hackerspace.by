User::ROLES.each do |rolename|
  puts "Create role: #{rolename}"
  Role.find_or_create_by(name: rolename)
end

unless Rails.env.production?
  Project.destroy_all
  User.destroy_all
  Device.destroy_all
  Event.destroy_all
  News.destroy_all

  admin = User.create(email: 'admin@hackerspace.by', password: '111111')
  admin.roles << Role.find_by(name: 'admin')

  User.create(email: 'developer@hackerspace.by', password: '111111')
  User.create(email: 'developer2@hackerspace.by', password: '111111')

  7.times do
    Project.create!(name: Faker::Commerce.product_name,
                    short_desc: Faker::Lorem.paragraph(rand(2..4)),
                    full_desc: Faker::Lorem.paragraph(rand(7..20)),
                    user: User.all.sample,
                    photo: File.open(Dir['public/images/*.jpg'].sample))
  end
  7.times do
    News.create!(title: Faker::Commerce.product_name,
                 short_desc: Faker::Lorem.paragraph(rand(5..12)),
                 description: Faker::Lorem.paragraph(rand(7..20)),
                 public: true,
                 markup_type: 'html',
                 photo: File.open(Dir['public/images/*.jpg'].sample))
  end

  Device.create(name: 'device1', password: '111111')
  Device.create(name: 'device2', password: '111111')

  60.times do
    Event.create(event_type: %w(light dark).sample, value: %w(on off).sample, device: Device.all.sample)
  end

  Device.all.each(&:mark_repeated_events)
end


Setting.create(key: 'bePaid_ID', value: '', description: 'ID магазина из личного кабинета bePaid')
Setting.create(key: 'bePaid_secret', value: '', description: 'Секретный ключ из личного кабинета bePaid')
Setting.create(key: 'bePaid_baseURL', value: 'https://api.bepaid.by', description: 'Базовый адрес для запросов к API bePaid')
Setting.create(key: 'bePaid_serviceNo', value: '248', description: 'Номер услуги в bePaid для членских взносов')
Setting.create(key: 'bib_baseURL', value: 'https://ibank.belinvestbank.by/', description: 'Bank API base URL')
Setting.create(key: 'bib_login', value: '', description: 'Login for Belinvestbank')
Setting.create(key: 'bib_password', value: '', description: 'Password for Belinvestbank')

