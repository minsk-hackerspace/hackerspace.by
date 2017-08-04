#!/usr/bin/ruby
# encoding: utf-8

require 'csv'
require './bepaid.rb'

bp = BePaid::BePaid.new 'https://api.bepaid.by', '<ID>', '<SECRET KEY>'
amount = 50.00

#amount is (amoint in BYN)*100
bill = {
  request: {
    amount: (amount * 100).to_i,
    currency: 'BYN',
    description: 'Членский взнос',
    email: 'jekhor@gmail.com',
    notification_url: 'https://hackerspace.by/admin/erip_transactions/bepaid_notify',
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

CSV.foreach(ARGV[0], headers: true) do |rec|

  next if rec[1].nil? or rec[1] == ''
  req = bill[:request]
  req[:email] = rec[3]
  req[:order_id] = rec[0]
  req[:customer][:first_name] = rec[1]
  req[:customer][:last_name] = rec[2]
  req[:payment_method][:account_number] = rec[0]

#  puts JSON.pretty_generate bill
  res = bp.post_bill bill
  puts JSON.pretty_generate res
end
