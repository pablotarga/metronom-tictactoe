FROM ruby:2.5.3

RUN gem install bundler

ENV APP_ROOT /app
RUN mkdir -p ${APP_ROOT}
RUN chown -R 1000:1000 ${APP_ROOT}

WORKDIR ${APP_ROOT}

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

RUN bundle install

COPY . ${APP_ROOT}

CMD ["ruby","-I","lib","app.rb"]
