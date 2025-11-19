# Make sure RUBY_VERSION matches the Ruby version in .ruby-version
FROM ruby:3.4.7

# Rails app lives here
WORKDIR /rails

# Install packages needed to build gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential libpq-dev nodejs && \
    rm -rf /var/lib/apt/lists/*

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle install --without production

# Copy application code
COPY . .

# Entrypoint prepares the database
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

EXPOSE 3000
CMD cp config/database.example.yml config/database.yml \
 && rake db:create \
 && rake db:migrate \
 && rake db:seed \
# && rails db:setup --trace \
 && rails server  --binding=0.0.0.0
