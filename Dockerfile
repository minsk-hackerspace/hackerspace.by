FROM ruby:2.7

WORKDIR /app
EXPOSE 3000

# add js runtime
RUN apt-get update \
 && apt-get install -y nodejs \
 && rm -rf /var/lib/apt/lists/*

COPY Gemfile Gemfile.lock Rakefile ./
RUN bundle version
RUN gem install bundler
RUN bundle install --without production

COPY bin/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

CMD cp config/database.example.yml config/database.yml \
 && rails db:setup \
 && rails server  --binding=0.0.0.0
