source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1'
gem 'rails-i18n', '~> 5.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'cancancan', '~> 2.0'
gem 'devise'
gem 'devise-i18n'
gem 'bootstrap-sass', '>= 3.4.1'
gem 'haml'
gem 'haml-rails'
gem 'rest-client'
gem 'whenever', require: false

#gem 'copycopter_client', '~> 2.0.1'
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'paperclip', '~> 5.2.0'
gem 'responders', '~> 2.0'
gem 'sanitize', '~> 4.6.3'
gem 'redcarpet'
gem 'comma'
gem 'factory_girl_rails', '~> 4.0', require: false
gem 'will_paginate', '~> 3.1.0'
gem 'chartkick'
gem 'groupdate'

gem 'font-awesome-rails'

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'thin', platform: :ruby
  gem 'mina', '~> 1.2'
  gem 'annotate'
  gem 'letter_opener'
end

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'pry'
  gem 'rspec-rails'
  gem 'sqlite3'
  gem 'faker'
  gem 'brakeman', require: false
  gem 'bundler-audit', require: false
end

group :test do
  gem 'shoulda-matchers', '2.8.0'
  gem 'ffaker'
  gem 'rails-controller-testing'
end

group :production do
  gem 'pg', '< 1.0'
  gem 'puma', '~> 3.0'
end
