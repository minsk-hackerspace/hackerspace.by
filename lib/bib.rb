#!/usr/bin/ruby
# encoding: utf-8

require 'rest-client'
require 'nokogiri'


module BelinvestbankApi
  HEADERS = {
    'Accept':'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
    'Accept-Charset':'utf-8, iso-8859-1, utf-16, *;q=0.7',
    'Accept-Language':'ru-RU,ru;q=0.8,en-US;q=0.6,en;q=0.4',
    'Connection':'keep-alive',
    'User-Agent':'Mozilla/5.0 (Linux; U; Android 4.0.4; ru-ru; Android SDK built for x86 Build/IMM76D) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 Mobile Safari/534.30',
  }

  class Bib

    def initialize(base_url, login, password)
      @base_url = base_url
      @base_url = @base_url[0..-2] if @base_url[-1] == '/'
      @login = login
      @password = password
      @cookies = {}
      RestClient.log = STDERR
    end

    def login
      r = query :get, '/signin'

      doc = Nokogiri::HTML(r.body)

      keyLang = ''
      doc.css('.authLayout #data script').each do |data|
        if data.to_s =~ /var keyLang =\s*(.*);/ then
          str = $1
          keyLang = str[1..-2].split(',').map {|e| e[1..-2].to_i}
        end
      end

      begin
        r = query :post, '/signin', {login: @login, password: encode_password(@password, keyLang), typeSessionKey: 0}

        if r.code == 200
          raise "Bank auth failed"
        end
      rescue RestClient::Exception => e
        if e.http_code == 302

          r = query :get, e.http_headers[:location]

          if e.http_headers[:location] == '/signin' and r.body.include?('showDialog')
            begin
              r = query :post, '/confirmationCloseSession'
            rescue RestClient::Exception => e
              r = e.response
              raise e unless e.http_code == 302
            end
          end
        end
      end
      r
    end

    def logout
      query :get, '/logout'
    end

    def fetch_accounts
      r = query :get, '/corporate/accounts'

      accounts = {}

      doc = Nokogiri::HTML(r.body)
      doc.css('.accounts-wrapper').each do |item|
        acc = item.css('.accountNumber').text
        balance = item.css('.accountBalance').text.delete(' ')
        type = item.css('.accountType').text
        currency = item.css('.accountCurrency').text
        acc_id = item['data-row-id']

        accounts[acc] = {balance: balance, type: type, currency: currency, id: acc_id}
      end
      accounts
    end

    def fetch_log(account_id, start_date=nil, end_date=nil)
      start_date = start_date.strftime('%d.%m.%y') if start_date.respond_to? :strftime
      end_date = end_date.strftime('%d.%m.%y') if end_date.respond_to? :strftime

      r = query :post, '/corporate/accounts/history', { account_id: account_id, dateFrom: start_date, dateTo: end_date}
      r = query :post, '/corporate/accounts/history/csv'
      r.body.force_encoding('windows-1251').encode('utf-8')
    end

    private

    def query(method, path, body = nil)
      begin
        r = RestClient::Request.execute method: method,
          url: @base_url + path,
          headers: HEADERS,
          payload: body,
          cookies: @cookies

        @cookies = r.cookies
      rescue RestClient::Exception => e
        @cookies = e.response.cookies if e.response and e.response.cookies
        raise e
      end
      r
    end

    def encode_password(password, key)
      lang = ['Q','W','E','R','T','Y','U','I','O','P','A','S','D','F','G','H','J','K','L','Z','X','C','V','B','N','M',
              'q','w','e','r','t','y','u','i','o','p','a','s','d','f','g','h','j','k','l','z','x','c','v','b','n','m',
              'Й','Ц','У','К','Е','Н','Г','Ш','Щ','З','Х','Ъ','Ф','Ы','В','А','П','Р','О','Л','Д','Ж','Э','Я','Ч','С',
              'М','И','Т','Ь','Б','Ю','й','ц','у','к','е','н','г','ш','щ','з','х','ъ','ф','ы','в','а','п','р','о','л',
              'д','ж','э','я','ч','с','м','и','т','ь','б','ю','1','2','3','4','5','6','7','8','9','0','_','.','-'];

      dict = {}
      lang.each_index {|i| dict[lang[i]] = key[i].chr(Encoding::UTF_8)}

      encrypted_pass = ''
      password.each_char do |c|
        if dict.include? c
          encrypted_pass += dict[c]
        else
          encrypted_passs += c
        end
      end
      puts encrypted_pass
      encrypted_pass
    end

  end

end


