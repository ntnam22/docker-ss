FROM alpine:latest


ENV SENSU_VERSION=1.1.1-1

RUN apk update
RUN apk add --no-cache build-base curl wget libffi-dev ruby-bundler ruby-dev ruby-io-console libxml2-dev libxslt-dev bash dumb-init ca-certificates libxml2 zlib-dev lm_sensors lm_sensors-detect ruby-rdoc ruby ruby-irb


ENV PATH /opt/sensu/embedded/bin:$PATH
RUN apk update
RUN gem install --no-document yaml2json
RUN gem install json -v 1.8.6
RUN gem install sensu

#ENV DUMB_INIT_VERSION=1.2.0
#RUN \
#    curl -Ls https://github.com/Yelp/dumb-init/releases/download/v${DUMB_INIT_VERSION}/dumb-init_${DUMB_INIT_VERSION}_amd64.deb > dumb-init.deb &&\
#    dpkg -i dumb-init.deb &&\
#    rm dumb-init.deb

ENV ENVTPL_VERSION=0.2.3
RUN \
    curl -Ls https://github.com/arschles/envtpl/releases/download/${ENVTPL_VERSION}/envtpl_linux_amd64 > /usr/local/bin/envtpl &&\
    chmod +x /usr/local/bin/envtpl

COPY templates /etc/sensu/templates
COPY bin /bin/

ENV DEFAULT_PLUGINS_REPO=sensu-plugins 
ENV    DEFAULT_PLUGINS_VERSION=master 

    #Client Config
ENV    CLIENT_SUBSCRIPTIONS=all,default 
ENV    CLIENT_BIND=127.0.0.1 
ENV    CLIENT_DEREGISTER=true 

    #Transport
ENV    TRANSPORT_NAME=redis 

ENV    RABBITMQ_PORT=5672 
ENV    RABBITMQ_HOST=rabbitmq 
ENV    RABBITMQ_USER=guest 
ENV   RABBITMQ_PASSWORD=guest 
ENV    RABBITMQ_VHOST=/ 
ENV    RABBITMQ_PREFETCH=1 
ENV   RABBITMQ_SSL_SUPPORT=false 
ENV    RABBITMQ_SSL_CERT='' 

ENV    RABBITMQ_SSL_KEY='' 
ENV    REDIS_HOST=redis 
ENV    REDIS_PORT=6379 
ENV    REDIS_DB=0 
ENV    REDIS_AUTO_RECONNECT=true 
ENV    REDIS_RECONNECT_ON_ERROR=false 

    #Common Config
ENV    RUNTIME_INSTALL='' 
ENV    LOG_LEVEL=warn 
ENV    CONFIG_FILE=/etc/sensu/config.json 
ENV    CONFIG_DIR=/etc/sensu/conf.d 
ENV    CHECK_DIR=/etc/sensu/check.d 
ENV    EXTENSION_DIR=/etc/sensu/extensions 
ENV    PLUGINS_DIR=/etc/sensu/plugins 
ENV    HANDLERS_DIR=/etc/sensu/handlers 

    #Config for gathering host metrics
ENV    HOST_DEV_DIR=/dev 
ENV    HOST_PROC_DIR=/proc 
ENV    HOST_SYS_DIR=/sys

RUN mkdir -p $CONFIG_DIR $CHECK_DIR $EXTENSION_DIR $PLUGINS_DIR $HANDLERS_DIR



EXPOSE 4567
VOLUME ["/etc/sensu/conf.d"]

ENTRYPOINT ["/usr/bin/dumb-init", "--", "/bin/start"]
