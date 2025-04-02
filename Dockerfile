FROM ruby:3.3.3

ARG RAILS_MASTER_KEY
ENV RAILS_MASTER_KEY=${RAILS_MASTER_KEY}

RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  nodejs \
  yarn \
  libvips \
  libxml2-dev \
  libxslt1-dev \
  zlib1g-dev

WORKDIR /app

ENV RAILS_ENV=production
ENV BUNDLE_WITHOUT=development:test

COPY Gemfile Gemfile.lock ./
RUN gem install bundler:2.5.23 && bundle install --jobs 4 --retry 3

COPY . .

RUN bundle exec rake assets:precompile

EXPOSE 3000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
