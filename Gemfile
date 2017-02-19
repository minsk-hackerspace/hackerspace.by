source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.0', '>= 5.0.0.1'
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
gem 'cancancan', '~> 1.10'
gem 'devise'
gem 'devise-i18n'
gem 'bootstrap-sass', '>= 3.1.1'
gem 'haml'
gem 'haml-rails'
gem 'pg'

#gem 'copycopter_client', '~> 2.0.1'
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'paperclip'
gem 'responders', '~> 2.0'
gem 'sanitize'
gem 'redcarpet'
gem 'comma'
gem 'factory_girl_rails', '~> 4.0', require: false

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'thin', platform: :ruby
  gem 'mina'
  gem 'faker'
  gem 'pry'
  gem 'annotate'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'rspec-rails'
end

group :test do
  gem 'shoulda-matchers', '2.8.0'
  gem 'ffaker'
end

group :production do
  gem 'puma', '~> 3.0'
end
