FROM nginx:stable

ARG VERSION=v3.9.0
ENV HTTP_PORT=8000

RUN curl -o /usr/local/bin/gomplate \
    -sSL https://github.com/hairyhenderson/gomplate/releases/download/$VERSION/gomplate_linux-amd64-slim \
    && chmod +x /usr/local/bin/gomplate

COPY nginx.template.conf nginx.template.conf
COPY start.sh /docker-entrypoint.d/start.sh
