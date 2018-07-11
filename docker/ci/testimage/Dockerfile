FROM docker

ENV KUBE_LATEST_VERSION="v1.9.3"

RUN apk add --update ca-certificates \
 && apk add --update -t deps curl \
 && curl -L https://storage.googleapis.com/kubernetes-release/release/${KUBE_LATEST_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl \
 && chmod +x /usr/local/bin/kubectl \
 && apk del --purge deps \
&& rm /var/cache/apk/*

RUN apk add alpine-sdk ruby ruby-dev nodejs yarn python3 py3-pip --no-cache
RUN pip3 install docker-compose=="1.19.0"
RUN gem install bigdecimal --no-document
RUN gem install dctl_rb -v '0.12.0' --no-document

COPY docker/ci/testimage/*.sh /etc/
