FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -yq --no-install-recommends \
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
HEALTHCHECK --interval=5s --timeout=3s --retries=3 CMD curl -f http://localhost || exit 1
CMD apachectl -D FOREGROUND 

