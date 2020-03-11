unless Rails.env.production?
  Mac.destroy_all
  Role.destroy_all
  NfcKey.destroy_all
  Project.destroy_all
  Device.destroy_all
  Event.destroy_all
  News.destroy_all
  Setting.destroy_all
  User.destroy_all
  EripTransaction.destroy_all

  Setting.create(key: 'bePaid_ID', value: '', description: 'ID магазина из личного кабинета bePaid')
  Setting.create(key: 'bePaid_secret', value: '', description: 'Секретный ключ из личного кабинета bePaid')
  Setting.create(key: 'bePaid_baseURL', value: 'https://api.bepaid.by', description: 'Базовый адрес для запросов к API bePaid')
  Setting.create(key: 'bePaid_serviceNo', value: '248', description: 'Номер услуги в bePaid для членских взносов')
  Setting.create(key: 'bib_baseURL', value: 'https://ibank.belinvestbank.by/', description: 'Bank API base URL')
  Setting.create(key: 'bib_loginBaseURL', value: 'https://login.belinvestbank.by/', description: 'Bank API base URL for login')
  Setting.create(key: 'bib_login', value: '', description: 'Login for Belinvestbank')
  Setting.create(key: 'bib_password', value: '', description: 'Password for Belinvestbank')

  User::ROLES.each do |rolename|
    puts "Create role: #{rolename}"
    Role.find_or_create_by(name: rolename)
  end


  admin = User.create(email: 'admin@hackerspace.by', password: '111111', last_name: 'Бердымухаммедов', first_name: 'Гурбангулы')
  admin.roles << Role.find_by(name: 'admin')

  user1 = User.create(email: 'developer@hackerspace.by', password: '111111', last_name: 'Рабинович', first_name: 'Давид')
  user1.macs << Mac.create(address: 'a0:a0:a0:a0:a1:a1')
  user1.macs << Mac.create(address: 'a0:a0:a0:a0:a1:a2')
  user1.macs << NfcKey.create(body: 'a0a0a0a0')
  user1.macs << NfcKey.create(body: 'b0ab0b0b0')

  user2 = User.create(email: 'developer2@hackerspace.by', password: '111111', last_name: 'Ковалёв', first_name: 'Иван')
  user2.macs << Mac.create(address: 'a0:a0:a0:a0:a2:a1')
  user2.macs << Mac.create(address: 'a0:a0:a0:a0:a2:a2')
  user2.macs << NfcKey.create(body: 'c0c0c0c0')
  user2.macs << NfcKey.create(body: 'd0d0d0d0')

  device = User.create(email: 'device@hackerspace.by', password: '111111')
  device.roles << Role.find_by(name: 'device')

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

  60.times do
    time = Faker::Time.between(1.year.ago, Date.today)
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
            {'request_id': Faker::Number.number(10),
             'service_no': Faker::Number.between(248, 249),
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
    p = Payment.create(erip_transaction: et,
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

