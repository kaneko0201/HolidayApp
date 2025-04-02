FROM ruby:3.3.3

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
RUN gem install bundler:2.5.23 && bundle install

COPY . .

ARG RAILS_MASTER_KEY
ENV RAILS_MASTER_KEY=${RAILS_MASTER_KEY}
RUN bundle exec rake assets:precompile

EXPOSE 3000
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
