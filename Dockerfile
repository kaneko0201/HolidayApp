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

ENV RAILS_ENV=production
ENV RAILS_SERVE_STATIC_FILES=1



# RUN bundle exec rake assets:precompile && \
#     bundle exec rails webpacker:compile

EXPOSE 3000
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
