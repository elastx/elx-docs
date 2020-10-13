FROM nginxinc/nginx-unprivileged:stable-alpine

LABEL maintainer="ELASTX Infra Team <team-infra@elastx.se>" app="elx-docs"

ADD public /usr/share/nginx/html
