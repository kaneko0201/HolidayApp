FROM ruby:3.3.3

ENV NODE_OPTIONS=--max-old-space-size=2048

RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get update -qq && apt-get install -y \
    nodejs \
    libpq-dev \
    libvips \
    libxml2-dev \
    libxslt1-dev \
    zlib1g-dev \
    build-essential \
    gnupg

RUN npm install -g yarn@1.22.19

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN gem install bundler:2.5.23 \
 && bundle config set deployment true \
 && bundle config set without 'test'

 RUN bundle config set build.libv8-node --disable-system-v8 \
 && bundle install --jobs=1 --retry=3

COPY . .


ENV NODE_OPTIONS=--openssl-legacy-provider

# credentials を使わない場合、SECRET_KEY_BASE を自前でセット
ENV RAILS_ENV=production

# assets:precompile に SECRET_KEY_BASE が必要なら、事前に渡す
# Docker run 時に渡してもOKだけど、ここで必要なら ARG で受け取って ENV に変換しておくとよい
ARG SECRET_KEY_BASE
ENV SECRET_KEY_BASE=${SECRET_KEY_BASE}

RUN bundle exec rake assets:precompile

EXPOSE 3000
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
