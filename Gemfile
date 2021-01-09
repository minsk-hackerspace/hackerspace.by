source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.0'
gem 'rails-i18n', '~> 6.0'
# Use SCSS for stylesheets
gem 'sassc-rails'
gem 'sassc'#, '= 2.1.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'cancancan'
gem 'devise'
gem 'devise-i18n'
gem 'bootstrap-sass', '>= 3.4.1'
gem 'haml'
gem 'haml-rails'
gem 'rest-client'
gem 'whenever', require: false
gem 'rack-proxy'

#gem 'copycopter_client', '~> 2.0.1'
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'paperclip', '~> 5.2.0'
gem 'responders'
gem 'sanitize'
gem 'redcarpet'
gem 'comma'
gem 'will_paginate', '~> 3.1.0'
gem 'chartkick'
gem 'groupdate'
gem 'tinymce-rails'
gem 'tinymce-rails-langs'

gem 'font-awesome-rails'

gem 'telegram-bot-ruby'

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'thin', platform: :ruby
  gem 'annotate'
  gem 'letter_opener'
  # Ruby deployment tool (like Ansible, but in Ruby)
  gem 'mina', '~> 1.2'
end

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'pry'
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'sqlite3'
  gem 'faker'
  gem 'brakeman', require: false
  gem 'bundler-audit', require: false
end

group :test do
  gem 'shoulda-matchers', '=4.3.0'
  gem 'ffaker'
  gem 'rails-controller-testing'
end

group :production do
  gem 'pg'
  gem 'puma'
end
