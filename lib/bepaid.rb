#!/usr/bin/ruby
# encoding: utf-8

require 'rest-client'
require 'json'

module BePaid
  class BPError < RuntimeError
    attr_accessor :http_body

    def initialize(message=nil, http_body=nil)
      @http_body = http_body
      super(message)
    end
  end

  #TODO implement validation
#  MANDATORY_ATTRS = [:amount, :currency, :description, :order_id, :email, :ip, :payment_method]
  MANDATORY_ATTRS = [:request, :customer, :payment_method]
  class Bill
    def initialize(options = {})
      @attributes = Hash.new
      options = options.inject({}) {|memo, (k, v)| memo[k.to_sym] = v; memo }
      @attributes.merge! options
    end

    def [](key)
      @attributes[key.to_sym]
    end

    def []=(key, val)
      @attributes[key.to_sym] = val
    end

    def validate
      errors = []
      MANDATORY_ATTRS.each do |key|
        errors << {attribute: key, error: "#{key} should be defined"} if @attributes[key].nil?
      end
      [errors.empty?, errors]
    end

    def to_json
      valid, errors = validate
      raise BPError, "Bill is invalid:\n#{errors.map {|e| e[:error]}.join("\n")}" unless valid
      JSON.pretty_generate @attributes
    end

    def to_s
      to_json
    end
  end

  ERRORS = {
    'pending' => 'Платежное требование создано успешно',
    'auto_created' => 'Автоматически созданное требование',
    'expired' => 'Срок оплаты истёк',
    'permanent' => 'Постоянно действующее требование',
    'successful' => 'Оплата проведена успешно',
    'failed' => 'Оплата проведена не успешно',
    'deleted' => 'Платёжное поручение удалено'
  }
  class BePaid
    def initialize(base_url, user, password)
      @base_url = base_url
      @auth = {username: user, password: password}
      @cookies = Hash.new
      RestClient.log = STDERR
    end

    def post_bill(bill)
      r = query_api :post, '/beyag/payments', bill
      bill_status = JSON.parse r.body
      raise BPError, ERRORS[bill_status['transaction']['status']], r.body unless ['pending', 'permanent'].include? bill_status['transaction']['status']
      bill_status
    end

    def bill(options={})
      path = "/beyag/payments/?order_id=#{options[:order_id]}" if options[:order_id]
      path = "/beyag/payments/#{options[:uid]}" if options[:uid]
      r = query_api :get, path
      JSON.parse r.body
    end

    def delete_bill(id)
      path = "/beyag/payments/#{id}"
      r = query_api :delete, path
      JSON.parse r.body
    end

    private

    def log(message)
      return unless RestClient.log
      RestClient.log << message
    end

    def query_api(method, path, body = nil)
      body = body.to_json unless body.nil?
      raise RuntimeError.new "No credentials for bePaid" if @auth[:username].nil? or @auth[:username] == ''
      begin
        r = RestClient::Request.execute method: method,
          url: @base_url + path,
          payload: body,
          cookies: @cookies,
          user: @auth[:username],
          password: @auth[:password],
          headers: {content_type: :json, accept: :json}
      rescue => e
        log e.message
        log e.http_.body if e.respond_to? :http_body
        raise e
      end
      r
    end

  end

end

if $0 == __FILE__
  bp = BePaid::BePaid.new 'https://api.bepaid.by', '<ID>', '<SECRET KEY>'

  amount = 400.00

  #amount is (amoint in BYN)*100
  bill = {
    request: {
      amount: (amount * 100).to_i,
      currency: 'BYN',
      description: 'Членский взнос',
      email: 'jekhor@gmail.com',
      ip: '127.0.0.1',
      order_id: '4',
      customer: {
        first_name: 'Евгений',
        last_name: 'Хоружий',
      },
      payment_method: {
        type: 'erip',
        account_number: 4,
        permanent: 'true',
        editable_amount: 'true',
        service_no: 248,
      }
    }
  }

#  res = bp.post_bill bill
#  puts JSON.pretty_generate res

#  res = bp.bill uid: '005de8b0-12b9-43ef-a6bf-e9d91bcaf340'
#  puts JSON.pretty_generate res

#  res = bp.delete_bill '27014608-35a8-4108-a5d3-98e89a57b54d'
#  puts JSON.pretty_generate res

end
