FROM nginx

MAINTAINER negokaz <negokaz@gmail.com>

RUN apt-get update \
 && apt-get install -y curl unzip

WORKDIR /tmp
RUN curl --silent --location \
    --url http://bob.nem.ninja/lightwallet-standalone-1.7-cdn-nginx1.8.zip \
    --output lightwallet-standalone.zip \
 && unzip -P 'nem' lightwallet-standalone.zip \
 && mkdir /opt/lightwallet-standalone \
 && mv ./lightwallet-standalone-*/* /opt/lightwallet-standalone \
 && rmdir ./lightwallet-standalone-*

ADD nginx.conf /opt/lightwallet-standalone/conf/nginx.conf

# forward request and error logs to docker log collector
RUN ln -sf /dev/stderr /opt/lightwallet-standalone/logs/error.log \
 && ln -sf /dev/stdout /opt/lightwallet-standalone/logs/access.log

# cleanup
RUN apt-get --purge -y remove curl unzip \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["nginx", "-g", "daemon off;", "-p", "/opt/lightwallet-standalone", "-c", "/opt/lightwallet-standalone/conf/nginx.conf"]
