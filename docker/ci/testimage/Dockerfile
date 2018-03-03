FROM docker

ENV KUBE_LATEST_VERSION="v1.9.3"

RUN apk add --update ca-certificates \
 && apk add --update -t deps curl \
 && curl -L https://storage.googleapis.com/kubernetes-release/release/${KUBE_LATEST_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl \
 && chmod +x /usr/local/bin/kubectl \
 && apk del --purge deps \
&& rm /var/cache/apk/*

RUN apk add alpine-sdk ruby ruby-dev py-pip --no-cache
RUN pip install docker-compose
RUN gem install bigdecimal --no-document
RUN gem install dctl_rb -v '0.10.4' --no-document
