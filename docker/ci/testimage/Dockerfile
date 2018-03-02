FROM docker

RUN apk add alpine-sdk ruby ruby-dev py-pip --no-cache
RUN pip install docker-compose
RUN gem install bigdecimal --no-document
RUN gem install dctl_rb -v '0.10.4' --no-document
