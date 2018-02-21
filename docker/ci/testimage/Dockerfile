FROM docker

RUN apk add alpine-sdk ruby ruby-dev py-pip --no-cache
RUN gem install bigdecimal --no-document
RUN gem install dctl_rb -v '0.9.1' --no-document
RUN pip install docker-compose
