namespace :wg_configs do
  desc 'Create default WireGuard settings if they are missing'
  task ensure_settings: :environment do
    WgConfig.ensure_default_settings!
  end

  desc 'Generate default WireGuard configs for users missing one'
  task generate_defaults: [:environment, :ensure_settings] do
    output_dir = Rails.root.join(ENV.fetch('OUTPUT_DIR', 'tmp/wg_configs'))
    FileUtils.mkdir_p(output_dir)

    User.find_each do |user|
      next if user.wg_configs.exists?(name: 'default')

      wg_config = user.wg_configs.create!(name: 'default')
      File.write(output_dir.join("wg-hackerspace-user-#{user.id}.conf"), wg_config.to_s)
    end
  end
end
