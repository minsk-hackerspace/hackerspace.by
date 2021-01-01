# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

every 1.day, at: '9:00 am' do
  runner 'NotificationsService.new.notify_debitors'
  runner 'NotificationsService.new.notify_telegram'
end

every 1.day, at: '12:00 am' do
  runner 'SuspendUsersService.new.set_users_as_suspended'
end

every 1.hour do
  runner 'BankFetcherService.fetch_balance'
end

every 4.hours do
  runner 'BankFetcherService.fetch_transactions'
end
