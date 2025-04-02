FROM ruby:3.3.3

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

COPY Gemfile Gemfile.lock ./
RUN gem install bundler:2.5.23 && bundle install

COPY . .

EXPOSE 3000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
