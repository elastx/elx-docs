FROM node:21 AS builder
ARG LOCALTEST=""

ENV HUGO_ENV production
ENV HUGO_VERSION 0.123.4
ENV HTMLTEST_VERSION 0.17.0
ENV GOLANG_VERSION 1.21.7

WORKDIR /project

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN curl -LsS https://github.com/wjdp/htmltest/releases/download/v${HTMLTEST_VERSION}/htmltest_${HTMLTEST_VERSION}_linux_amd64.tar.gz \
| tar -C /usr/local/bin/ -xzf - htmltest

RUN curl -LsS https://go.dev/dl/go${GOLANG_VERSION}.linux-amd64.tar.gz | tar -C /usr/local/ -xzf - && \
ln -s /usr/local/go/bin/go /usr/local/bin/go

RUN curl -LsS https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-amd64.tar.gz \
| tar -C /usr/local/bin/ -xzf - hugo

COPY . /project

RUN /project/npm-deps.sh && hugo mod get && git config --global --add safe.directory /project

RUN if [ -z "$LOCALTEST" ]; then hugo -v && htmltest -c htmltest.yml; fi

ENTRYPOINT [ "/project/entrypoint.sh" ]


FROM nginxinc/nginx-unprivileged:stable-alpine

LABEL maintainer="ELASTX Infra Team <team-infra@elastx.se>" app="dox-ng"

COPY --from=builder /project/public /usr/share/nginx/html