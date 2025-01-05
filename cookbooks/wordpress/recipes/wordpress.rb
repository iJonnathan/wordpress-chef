# Se descarga WordPress
remote_file '/tmp/wordpress.tar.gz' do
  source 'https://wordpress.org/latest.tar.gz'
  action :create
end

# Se extrae WordPress y se move a la raíz de /var/www/html
execute 'extract-wordpress' do
  command <<-EOH
    tar -xzf /tmp/wordpress.tar.gz -C /var/www/html/ &&
    mv /var/www/html/wordpress/* /var/www/html/ &&
    rmdir /var/www/html/wordpress
  EOH
  not_if { ::File.exist?('/var/www/html/index.php') }
end

# Configuracion de los permisos para WordPress
execute 'set-permissions' do
  command 'chown -R www-data:www-data /var/www/html'
  action :run
end

# Se descarga e instala wp-cli
execute 'install-wp-cli' do
  command <<-EOH
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar &&
    chmod +x wp-cli.phar &&
    mv wp-cli.phar /usr/local/bin/wp
  EOH
  creates '/usr/local/bin/wp'
  action :run
end

# Configuracion de wp-config.php 
template '/var/www/html/wp-config.php' do
  source 'wp-config.php.erb'
  owner 'www-data'
  group 'www-data'
  mode '0644'
  variables(
    db_name: node['wordpress']['db_name'],
    db_user: node['wordpress']['db_user'],
    db_password: node['wordpress']['db_password'],
    db_host: node['wordpress']['db_host']
  )
  action :create
end

# Se crea archivo .htaccess para WordPress
file '/var/www/html/.htaccess' do
  content <<-EOF
    <IfModule mod_rewrite.c>
    RewriteEngine On
    RewriteBase /
    RewriteRule ^index\\.php$ - [L]
    RewriteCond %{REQUEST_FILENAME} !-f
    RewriteCond %{REQUEST_FILENAME} !-d
    RewriteRule . /index.php [L]
    </IfModule>
  EOF
  owner 'www-data'
  group 'www-data'
  mode '0644'
  action :create
end

# Instalacion de WordPress usando wp-cli
execute 'install-wordpress' do
  command <<-EOH
    wp core install \
      --url='#{node['wordpress']['site_url']}' \
      --title='ChefBlog' \
      --admin_user='admin' \
      --admin_password='admin' \
      --admin_email='admin@example.com' \
      --path=/var/www/html \
      --allow-root
  EOH
  not_if "wp core is-installed --path=/var/www/html --allow-root"
  action :run
end