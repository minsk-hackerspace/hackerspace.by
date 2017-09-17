Setting.create(key: 'bePaid_ID', value: '', description: 'ID магазина из личного кабинета bePaid')
Setting.create(key: 'bePaid_secret', value: '', description: 'Секретный ключ из личного кабинета bePaid')
Setting.create(key: 'bePaid_baseURL', value: 'https://api.bepaid.by', description: 'Базовый адрес для запросов к API bePaid')
Setting.create(key: 'bePaid_serviceNo', value: '248', description: 'Номер услуги в bePaid для членских взносов')
Setting.create(key: 'bib_baseURL', value: 'https://ibank.belinvestbank.by/', description: 'Bank API base URL')
Setting.create(key: 'bib_login', value: '', description: 'Login for Belinvestbank')
Setting.create(key: 'bib_password', value: '', description: 'Password for Belinvestbank')

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

  EripTransaction.destroy_all
  60.times do
    time = Faker::Time.between(1.year.ago, Date.today)
    user = User.all.sample
    donate = Faker::Boolean.boolean(0.1)
    user.erip_transactions.create(
        status: 'successful',
        message: 'Операция успешно завершена.',
        transaction_type: 'payment',
        transaction_id: 'fddc5ffd-3e64-49bd-af67-2e1dc2e7ba8f',
        uid: 'fddc5ffd-3e64-49bd-af67-2e1dc2e7ba8f',
        order_id: user.id,
        amount: 50,
        currency: 'BYN',
        description: nil,
        tracking_id: user.id,
        transaction_created_at: time,
        expired_at: time + 30.minutes,
        paid_at: time + 10.seconds,
        test: nil,
        payment_method_type: 'erip',
        purpose: donate ? 'donate' : 'fee',
        billing_address:
            {'first_name': Faker::Name.first_name,
             'last_name': Faker::Name.last_name,
             'country': nil,
             'city': nil,
             'address': nil,
             'zip': nil,
             'phone': nil},
        customer: {'email': user.email, 'ip': '127.0.0.1'},
        payment:
            {'ref_id': 1664038138,
             'message': 'Операция успешно завершена.',
             'status': 'successful',
             'gateway_id': 2073},
        erip:
            {'request_id': Faker::Number.number(10),
             'service_no': donate ? 249 : 248,
             'account_number': user.id,
             'transaction_id': Faker::Number.number(10),
             'instruction':
                 ['г. Минск -> Общественные объединения, Профсоюзы -> Мастерская ИТТ ОО «БОИР»'],
             'service_info': ['Введите Ваш номер членского билета'],
             'receipt': ['Спасибо за оплату!'],
             'agent_code': 739,
             'agent_name': 'ОАО БЕЛИНВЕСТБАНК'},
    )
  end
end

