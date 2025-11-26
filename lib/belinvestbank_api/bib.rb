#!/usr/bin/ruby
# encoding: utf-8

require 'rest-client'
require 'nokogiri'

require_relative 'bib_parse'

module BelinvestbankApi
  HEADERS = {
    accept: 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
    'Accept-Charset':'utf-8, iso-8859-1, utf-16, *;q=0.7',
    'Accept-Language':'en-US;q=0.5,en;q=0.4',
    user_agent: 'Mozilla/5.0 (X11; Linux x86_64; rv:80.0) Gecko/20100101 Firefox/80.0',
  }

  class Bib
    def initialize(options = {})
      @base_url = options[:base_url]
      @base_url = @base_url[0..-2] if @base_url[-1] == '/'
      @login_base_url = options[:login_base_url]
      @login_base_url = @login_base_url[0..-2] if @login_base_url[-1] == '/'
      @login_name = options[:login_name]
      @password = options[:password]
      @cookies = {}
      @referrer = nil
      RestClient.log = STDERR
    end

    # Success path:
    # 1. GET https://login.belinvestbank.by/signin -> extract keyLang for password encoding
    # 2. POST https://login.belinvestbank.by/signin <- send login/password
    # 3. (2) returns code 302 (redirect) to http://ibank.belinvestbank.by/auth-callback?auth_code=<code>&type=simple_session -> go to it
    # 4. (3) redirects to https://ibank.belinvestbank.by/auth-callback?auth_code=<code>&type=simple_session
    #                       -> https://biz.belinvestbank.by/toggle-corporate-version
    #                       -> https://biz.belinvestbank.by/corporate
    #                       -> https://biz.belinvestbank.by/corporate?owner_id=<ID>
    #                       -> https://biz.belinvestbank.by/corporate/accounts/?owner_id=<ID>
    #
    # Errors:
    # 3a. (2) returns redirect to https://login.belinvestbank.by/signin and this page contains string 'showDialog' -> reset session (POST /confirmationCloseSession) and follow by redirects
    # 3b. (2) returns 200 -> auth failed


    def login
      r = query_login :get, '/signin'

      doc = Nokogiri::HTML(r.body)

      keyLang = doc.css('script').find do |data|
        Belinvestbankapi::Parse::keyLang(data)
      end || ''

      begin
        r = query_login :post, '/signin', {login: @login_name, password: encode_password(@password, keyLang), typeSessionKey: 0}

        if r.code == 200
          raise "Bank auth failed"
        end
      rescue RestClient::Exception => e
        if e.http_code == 302

          if e.http_headers[:location] == '/signin'
            r = query_login :get, e.http_headers[:location]
            raise e unless r.body.include?('showDialog')
            begin
              puts "Close old session"
              r = query_login :post, '/confirmationCloseSession'
            rescue RestClient::Exception => e1
              r = e1.response
              raise e1 unless e1.http_code == 302
#              puts r.body
              puts "Redirect to: " + e1.http_headers[:location]
              location = e1.http_headers[:location]
              if location[0] == '/'
                location = r.net_http_res.uri.to_s + location
              end
              r = query_common location, :get, ''
            end
#            puts r.body
          end

          if e.http_headers[:location].include? 'auth-callback'
            puts "Requesting auth-callback"

            r = query_common e.http_headers[:location], :get, ''
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
      doc.css('.blockAccount').each do |item|
        acc = item.css('.js-account-number-in-table').first['data-value']
        balance = item.css('.blockAccount__currentBalance .block__desc').text.delete(' ')
        type = item.css('.js-account-type-in-table').first['data-value']
        currency = item.css('.js-account-currency-in-table').first['data-value']
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

    attr_accessor :cookies

    def query_common(base_url, method, path, body = nil)
      begin
        r = RestClient::Request.execute method: method,
          url: base_url + path,
          headers: HEADERS.merge(referrer: @referrer),
          payload: body,
          cookies: cookies

        self.cookies = r.cookie_jar
        @referrer = r.net_http_res.uri
      rescue RestClient::Exception => e
        self.cookies = e.response.cookie_jar if e.response and e.response.cookies
        raise e
      end
      r
    end

    def query(method, path, body = nil)
      query_common(@base_url, method, path, body)
    end

    def query_login(method, path, body = nil)
      query_common(@login_base_url, method, path, body)
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
      encrypted_pass
    end

  end

end
