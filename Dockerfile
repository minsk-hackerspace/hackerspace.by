FROM ruby:3.3.5

# Install system dependencies
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs yarn \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app
EXPOSE 3000

COPY Gemfile Gemfile.lock Rakefile ./
RUN bundle version
RUN gem install bundler
RUN bundle install --without production

COPY bin/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

CMD cp config/database.example.yml config/database.yml \
 && rake db:create \
 && rake db:migrate \
 && rake db:seed \
# && rails db:setup --trace \
 && rails server  --binding=0.0.0.0
