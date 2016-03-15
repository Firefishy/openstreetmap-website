FROM ruby:2.3

RUN apt-get update -qq && apt-get install -y libmagickwand-dev libxml2-dev libxslt1-dev nodejs nodejs-legacy npm libpq-dev libsasl2-dev imagemagick --no-install-recommends

RUN mkdir -p /app
WORKDIR /app

# Copy the Gemfile as well as the Gemfile.lock and install
# the RubyGems. This is a separate step so the dependencies
# will be cached unless changes to one of those two files
# are made.
COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle config build.nokogiri --use-system-libraries && bundle install --jobs 20 --retry 5

# Install svgo
RUN npm install -g svgo

# Copy the main application.
COPY . ./
COPY config/example.database.yml ./config/database.yml
COPY config/example.application.yml ./config/application.yml

ENV RAILS_ENV development
ENV RACK_ENV development
ENV RAILS_SERVE_STATIC_FILES true

# Precompile Rails assets
RUN bundle exec rake assets:precompile

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3000"]
