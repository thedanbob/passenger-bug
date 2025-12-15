FROM debian:13-slim

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
      ruby \
      procps \
      git \
      curl \
      build-essential \
      libcurl4-openssl-dev \
      libssl-dev \
      zlib1g-dev \
      ruby-dev && \
    rm -rf /var/lib/apt/lists/*

RUN gem install rack --no-document

RUN git clone https://github.com/phusion/passenger.git && \
    cd passenger && \
    git submodule update --init --recursive && \
    git checkout bugfix/nginx_unbuffered_bug
RUN sed -i \
      's/if install_nginx/extra_nginx_configure_flags = "--with-debug"; if install_nginx/' \
      /passenger/bin/passenger-install-nginx-module && \
    /passenger/bin/passenger-install-nginx-module

RUN ln -sf /dev/stdout /opt/nginx/logs/access.log && \
    ln -sf /dev/stderr /opt/nginx/logs/error.log && \
    mkdir /srv/public

COPY config.ru /srv/
COPY nginx.conf /opt/nginx/conf/

VOLUME ["/uploads"]
CMD ["/opt/nginx/sbin/nginx", "-g", "daemon off;"]
