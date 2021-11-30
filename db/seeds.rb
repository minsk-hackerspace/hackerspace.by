unless Rails.env.production?

  [Mac, Role, NfcKey, Project, Device, Event, News, Setting, User, EripTransaction, Payment].each { |model| model.destroy_all }

  Setting.create(key: 'bePaid_ID', value: 'bepaidID', description: 'ID магазина из личного кабинета bePaid')
  Setting.create(key: 'bePaid_secret', value: 'bepaidSecret', description: 'Секретный ключ из личного кабинета bePaid')
  Setting.create(key: 'bePaid_baseURL', value: 'https://api.bepaid.by', description: 'Базовый адрес для запросов к API bePaid')
  Setting.create(key: 'bePaid_serviceNo', value: '248', description: 'Номер услуги в bePaid для членских взносов')
  Setting.create(key: 'bib_baseURL', value: 'https://ibank.belinvestbank.by/', description: 'Bank API base URL')
  Setting.create(key: 'bib_loginBaseURL', value: 'https://login.belinvestbank.by/', description: 'Bank API base URL for login')
  Setting.create(key: 'bib_login', value: '', description: 'Login for Belinvestbank')
  Setting.create(key: 'bib_password', value: '', description: 'Password for Belinvestbank')
  Setting.create(key: 'bramnikBotName', value: 'BramnikBot', description: 'Name of the Bramnik Telegram bot')

  remote_tariff = Tariff.create(
    ref_name: 'remote',
    name: 'Remote',
    description: 'Удалённый доступ',
    access_allowed: false,
    monthly_price: 10.0
  )

  Tariff.create(
    ref_name: 'remote+storage',
    name: 'Remote and Storage',
    description: 'Удалённый доступ с хранением коробок',
    access_allowed: false,
    monthly_price: 20.0
  )

  main_tariff = Tariff.create(
    ref_name: 'full',
    name: 'Основной тариф',
    description: 'Полный доступ в хакерспейс',
    access_allowed: true,
    monthly_price: 70.0
  )

  Tariff.create(
    ref_name: 'student',
    name: 'Студенческий',
    description: 'Полный доступ в хакерспейс, для студентов',
    access_allowed: true,
    monthly_price: 20.0
  )

  User::ROLES.each do |rolename|
    puts "Create role: #{rolename}"
    Role.find_or_create_by(name: rolename)
  end


  admin = User.create!(email: 'admin@hackerspace.by', password: '111111', last_name: 'Бердымухаммедов', first_name: 'Гурбангулы', tariff: main_tariff)
  admin.roles << Role.find_by(name: 'admin')
  admin.save

  user1 = User.create!(email: 'developer@hackerspace.by', password: '111111', last_name: 'Рабинович', first_name: 'Давид', tariff: main_tariff)
  user1.macs << Mac.create(address: 'a0:a0:a0:a0:a1:a1')
  user1.macs << Mac.create(address: 'a0:a0:a0:a0:a1:a2')
  user1.nfc_keys << NfcKey.create(body: 'a0a0a0a0')
  user1.nfc_keys << NfcKey.create(body: 'b0ab0b0b0')
  user1.save

  user2 = User.create!(email: 'developer2@hackerspace.by', password: '111111', last_name: 'Ковалёв', first_name: 'Иван', tariff: main_tariff)
  user2.macs << Mac.create(address: 'a0:a0:a0:a0:a2:a1')
  user2.macs << Mac.create(address: 'a0:a0:a0:a0:a2:a2')
  user2.nfc_keys << NfcKey.create(body: 'c0c0c0c0')
  user2.nfc_keys << NfcKey.create(body: 'd0d0d0d0')
  user2.save

  device = User.create!(email: 'device@hackerspace.by', password: '111111', tariff: main_tariff)
  device.roles << Role.find_by(name: 'device')
  device.save

  7.times do
    Project.create!(name: Faker::Commerce.product_name,
                    short_desc: Faker::Lorem.paragraph(sentence_count: rand(2..4)),
                    full_desc: Faker::Lorem.paragraph(sentence_count: rand(7..20)),
                    user: User.all.sample,
                    photo: File.open(Dir['public/images/*.jpg'].sample))
  end
  7.times do
    News.create!(title: Faker::Commerce.product_name,
                 short_desc: Faker::Lorem.paragraph(sentence_count: rand(5..12)),
                 description: Faker::Lorem.paragraph(sentence_count: rand(7..20)),
                 user: User.all.sample,
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

  60.times do
    time = Faker::Time.between(from: 1.year.ago, to: Date.today)
    user = User.all.sample
    uid = SecureRandom.uuid
    user.erip_transactions.create(
        status: 'successful',
        message: 'Операция успешно завершена.',
        transaction_type: 'payment',
        transaction_id: uid,
        uid: uid,
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
            {'request_id': Faker::Number.number(digits: 10),
             'service_no': Faker::Number.between(from: 248, to: 249),
             'account_number': user.id,
             'transaction_id': Faker::Number.number(digits: 10),
             'instruction':
                 ['г. Минск -> Общественные объединения, Профсоюзы -> Мастерская ИТТ ОО «БОИР»'],
             'service_info': ['Введите Ваш номер членского билета'],
             'receipt': ['Спасибо за оплату!'],
             'agent_code': 739,
             'agent_name': 'ОАО БЕЛИНВЕСТБАНК'},
    )
  end

  def get_payment_type(et)
    case et.erip['service_no']
    when 248
      'membership'
    when 249
      'donation'
    end
  end

  Payment.destroy_all
  EripTransaction.all.each do |et|
    next unless et.status == 'successful'
    start_date = end_date = nil
    u = nil
    if et.erip['service_no'] == 248
      start_date = et.paid_at
      end_date = et.paid_at + 1.month
      begin
        u = User.find(et.erip['account_number'])
      rescue
        u = nil
      end
    end
    p = Payment.create!(erip_transaction: et,
                       amount: et.amount,
                       paid_at: et.paid_at,
                       payment_type: get_payment_type(et),
                       payment_form: 'erip',
                       start_date: start_date,
                       end_date: end_date,
                       user: u)
    puts "Payment created: #{p.inspect} #{p.errors.inspect}"
  end

  BankTransaction.destroy_all
  BankTransaction.create(
      plus: 10,
      minus: 0,
      unp: 'unp',
      their_account: '000',
      our_account: '111',
      document_number: '123'
  )
  BankTransaction.create(
      plus: 0,
      minus: 2340,
      unp: 'unp',
      their_account: '000',
      our_account: '111',
      document_number: '1234'
  )

end

