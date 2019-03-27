FROM ruby:2.6.1
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
