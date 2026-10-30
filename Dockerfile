FROM php:8.5-apache

ARG TIMEZONE="Europe/Paris"
ENV DEBIAN_FRONTEND=noninteractive

# ── System tools ────────────────────────────────────────────────────
RUN apt-get update && apt-get install -y --no-install-recommends \
    acl \
    ca-certificates \
    curl \
    git \
    gnupg \
    nano \
    unzip \
    wget \
    zip \
    && rm -rf /var/lib/apt/lists/*

# ── PHP extensions (install-php-extensions gère les dépendances) ────
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions

RUN install-php-extensions \
    gd \
    intl \
    opcache \
    pdo_mysql \
    zip \
    apcu \
    redis \
    xdebug

# ── Timezone ────────────────────────────────────────────────────────
RUN ln -snf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
    && echo ${TIMEZONE} > /etc/timezone

# ── Apache modules ─────────────────────────────────────────────────
RUN a2enmod rewrite headers

# ── Composer ────────────────────────────────────────────────────────
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer




WORKDIR /var/www/html

EXPOSE 80

CMD ["apache2-foreground"]