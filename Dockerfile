FROM ruby:2.2.3

RUN apt-get update
RUN apt-get install -y nodejs
COPY . /etcdctl-web
RUN useradd rails
RUN chown -R rails.rails /etcdctl-web
USER rails
WORKDIR /etcdctl-web
ENV BUNDLE_APP_CONFIG /etcdctl-web/.bundle
RUN bundle install --deployment --path vendor/bundle --jobs 4 --without development test

EXPOSE 3000
ENTRYPOINT ["bundle", "exec"]
CMD ["rails", "s"]
