FROM ruby:3.2-slim
RUN apt-get update \
 && apt-get install -y --no-install-recommends git ca-certificates build-essential \
 && rm -rf /var/lib/apt/lists/*
RUN gem install bundler
ENV LANG=C.UTF-8
ENV WORKDIR=/fir-cli
ENV HOME=/fir-cli
RUN mkdir -p $WORKDIR
ADD ./ $HOME
WORKDIR $WORKDIR
RUN ["bundle", "install"]
RUN ["touch", "README.md"]
RUN ["rake", "install"]
ENTRYPOINT ["fir"]
