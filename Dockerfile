# The base image is created on Debian
FROM ruby:1.9.3

# From OTS instructions
RUN apt-get update
RUN apt-get install -y build-essential
RUN apt-get install -y ntp libyaml-dev libevent-dev zlib1g zlib1g-dev openssl libssl-dev libxml2 libreadline-gplv2-dev
RUN mkdir ~/sources

# For Ruby
RUN gem install bundler

#
# Setting up OTS
#
RUN adduser ots
RUN mkdir -p /etc/onetime /var/log/onetime /var/run/onetime /var/lib/onetime 
RUN chown ots /etc/onetime /var/log/onetime /var/run/onetime /var/lib/onetime
ADD . /home/ots/onetime
RUN cd /home/ots/onetime
RUN bundle install --frozen --deployment --without=dev

RUN cp -R ./etc/* /etc/onetime 
RUN bundle exec thin -e dev -R config.ru -p 7143 start

EXPOSE 7143