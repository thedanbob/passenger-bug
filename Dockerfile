FROM debian:12-slim

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
      gnupg \
      apt-transport-https \
      ca-certificates \
      curl && \
    curl -sS 'http://keyserver.ubuntu.com/pks/lookup?op=get&search=0x561F9B9CAC40B2F7' | gpg --dearmor -o /etc/apt/trusted.gpg.d/passenger.gpg && \
    echo "deb https://oss-binaries.phusionpassenger.com/apt/passenger bookworm main" | tee /etc/apt/sources.list.d/passenger.list && \
    apt-get update && \
    apt-get install -y \
      ruby \
      nginx \
      libnginx-mod-http-passenger && \
    rm -rf /var/lib/apt/lists/* && \
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log && \
    sed -i 's/worker_processes auto/worker_processes 1/' /etc/nginx/nginx.conf && \
    mkdir /var/run/passenger-instreg /srv/public && \
    gem install rack --no-document

COPY config.ru /srv/
COPY passenger.conf /etc/nginx/conf.d/

VOLUME ["/uploads"]
CMD ["/sbin/nginx", "-g", "daemon off;"]
