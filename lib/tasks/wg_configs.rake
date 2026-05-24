namespace :wg_configs do
  desc 'Create default WireGuard settings if they are missing'
  task ensure_settings: :environment do
    WgConfig.ensure_default_settings!
  end

  desc 'Generate default WireGuard configs for users missing one'
  task generate_defaults: [:environment, :ensure_settings] do
    User.find_each do |user|
      next if user.wg_configs.exists?(name: 'default')

      user.wg_configs.create!(name: 'default')
    end
  end
end
