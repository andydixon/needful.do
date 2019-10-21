FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -yq --no-install-recommends \
 supervisor consul \
    curl \
    apt-utils \
    apache2 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set locales
RUN a2enmod rewrite expires
WORKDIR /var/www/html

EXPOSE 80
RUN rm -fr /var/www/html
ADD src /var/www/html
HEALTHCHECK --interval=5s --timeout=3s --retries=3 CMD curl -f http://localhost || /shutdown.sh
ADD container/consultainer.conf /etc/supervisor/conf.d
ADD container/bootstrap.sh /bootstrap.sh
ADD container/shutdown.sh /shutdown.sh
RUN mkdir -p /etc/consul.d
ADD container/config.json /etc/consul.d/
RUN chmod +x /*.sh
CMD /bootstrap.sh

