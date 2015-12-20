source 'https://rubygems.org'

gem 'rails', '4.2.4'
gem 'rails-i18n'

gem 'thin', platform: :ruby, group: :development

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
group :production do
  gem 'pg'
end

gem 'jbuilder'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

gem 'devise', '~> 3.4.0'
gem 'devise-i18n'
gem 'sass-rails', '~> 4.0.3'
gem 'bootstrap-sass', '>= 3.1.1'
gem 'haml'
gem 'haml-rails'

#gem 'copycopter_client', '~> 2.0.1'
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'tail'
gem 'paperclip'
gem 'responders', '~> 2.0'
gem 'sanitize'
gem 'redcarpet'
gem 'comma'

group :development do
  gem 'capistrano', '~> 2'
  gem 'faker'
  gem 'web-console', '~> 2.0' #Rails 4.1+ recommended debug gem
  gem 'pry'
  gem 'quiet_assets'
  gem 'sqlite3'
end

group :development, :test do
  gem 'rspec-rails', '~> 3.0'
end
