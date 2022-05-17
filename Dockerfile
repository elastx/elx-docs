FROM nginxinc/nginx-unprivileged:stable-alpine

LABEL maintainer="ELASTX Infra Team <team-infra@elastx.se>" app="elx-docs"

COPY public /usr/share/nginx/html
