FROM ruby:3.2.2

WORKDIR /app

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs curl

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

EXPOSE 3001

CMD ["bash", "-c", "bundle exec rails db:prepare && bundle exec rails s -p 3001 -b 0.0.0.0"]
