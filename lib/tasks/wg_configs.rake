namespace :wg_configs do
  desc 'Generate default WireGuard configs for users missing one'
  task generate_defaults: :environment do
    User.find_each do |user|
      next if user.wg_configs.exists?(name: 'default')

      user.wg_configs.create!(name: 'default')
    end
  end
end
