FROM ruby:2.5.0

WORKDIR /app
EXPOSE 3000

# add js runtime
RUN apt-get update \
 && apt-get install -y nodejs \
 && rm -rf /var/lib/apt/lists/*

COPY Gemfile Gemfile.lock Rakefile ./
RUN bundle install --without production

CMD cp config/database.example.yml config/database.yml \
 && bundle exec rails db:setup \
 && bundle exec rails server  --binding=0.0.0.0
