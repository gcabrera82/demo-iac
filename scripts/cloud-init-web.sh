#cloud-config
package_update: true
package_upgrade: true

packages:
  - nginx
  - php-fpm
  - php-cli
  - php-xml
  - php-mbstring
  - php-zip
  - unzip
  - curl

runcmd:
  # ------------------------------------------
  # Instalar drivers de SQL Server para PHP
  # ------------------------------------------
  - curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
  - curl https://packages.microsoft.com/config/ubuntu/22.04/prod.list > /etc/apt/sources.list.d/mssql-release.list
  - apt-get update
  - ACCEPT_EULA=Y apt-get install -y msodbcsql18 mssql-tools18 unixodbc-dev
  - apt-get install -y php-pear php-dev
  - pecl install sqlsrv
  - pecl install pdo_sqlsrv
  - echo "extension=sqlsrv.so" >> /etc/php/8.1/fpm/php.ini
  - echo "extension=pdo_sqlsrv.so" >> /etc/php/8.1/fpm/php.ini

  # ------------------------------------------
  # Descargar index.php desde tu repositorio
  # ------------------------------------------
  - rm -f /var/www/html/index.nginx-debian.html
  - curl -o /var/www/html/index.php https://raw.githubusercontent.com/leandroamore/ppdemo/main/index.php

  # ------------------------------------------
  # Ajustar permisos
  # ------------------------------------------
  - chown -R www-data:www-data /var/www/html
  - chmod -R 755 /var/www/html

  # ------------------------------------------
  # Reiniciar servicios
  # ------------------------------------------
  - systemctl restart php8.1-fpm
  - systemctl restart nginx
