FROM ruby:2.4.2

ENV WORKDIR=/fir-cli
ENV HOME=/fir-cli

RUN gem install fir-cli

RUN mkdir -p $WORKDIR

WORKDIR $WORKDIR

CMD ["fir"]