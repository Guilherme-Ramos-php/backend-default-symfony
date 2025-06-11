# Estágio de build
FROM php:8.4-fpm AS builder

# Instalar dependências
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libpq-dev \
    && docker-php-ext-install pdo_pgsql opcache

# Instalar Swoole
RUN pecl install swoole \
    && docker-php-ext-enable swoole

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Configurar diretório de trabalho
WORKDIR /var/www/html

# Copiar arquivos do projeto
COPY . .

# Instalar dependências do projeto
RUN composer install --no-dev --optimize-autoloader

# Estágio de produção
FROM php:8.4-fpm

# Instalar dependências
RUN apt-get update && apt-get install -y \
    libpq-dev \
    && docker-php-ext-install pdo_pgsql opcache \
    && pecl install swoole \
    && docker-php-ext-enable swoole

# Criar usuário não-root
RUN useradd -ms /bin/bash app

# Configurar diretório de trabalho
WORKDIR /var/www/html

# Copiar arquivos do estágio de build
COPY --from=builder /var/www/html .
COPY --from=builder /usr/bin/composer /usr/bin/composer

# Ajustar permissões
RUN chown -R app:app /var/www/html

# Mudar para o usuário não-root
USER app

# Expor porta
EXPOSE 9501

# Comando para iniciar o servidor Swoole
CMD ["php", "bin/console", "swoole:server:start"] 