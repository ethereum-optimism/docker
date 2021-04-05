FROM nginx:stable

ARG VERSION=v3.9.0

RUN curl -o /usr/local/bin/gomplate \
    -sSL https://github.com/hairyhenderson/gomplate/releases/download/$VERSION/gomplate_linux-amd64-slim \
    && chmod +x /usr/local/bin/gomplate

RUN apt-get update \
    && apt-get -y install --no-install-recommends wget gnupg ca-certificates \
    && wget -O - https://openresty.org/package/pubkey.gpg | apt-key add - \
    && codename=$(grep -Po 'VERSION="[0-9]+ \(\K[^)]+' /etc/os-release) \
    && echo "deb http://openresty.org/package/debian $codename openresty" \
    | tee /etc/apt/sources.list.d/openresty.list \
    && apt-get update \
    && apt-get -y install openresty

RUN NGINX=$(which nginx) \
    && mv $NGINX $NGINX-old \
    && ln -s $(which openresty) $NGINX

COPY nginx.template.conf nginx.template.conf
COPY start.sh /docker-entrypoint.d/start.sh
