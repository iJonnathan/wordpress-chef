package 'apache2' do
    action :install
  end
  
  service 'apache2' do
    action [:enable, :start]
  end
  
  # Elimina el archivo predeterminado de Apache (index.html)
  file '/var/www/html/index.html' do
    action :delete
    only_if { ::File.exist?('/var/www/html/index.html') }
  end
  
  # Configura Apache para priorizar index.php
  execute 'enable-php-index' do
    command <<-EOH
      sed -i 's/DirectoryIndex .*/DirectoryIndex index.php index.html/' /etc/apache2/mods-enabled/dir.conf
    EOH
    notifies :restart, 'service[apache2]', :immediately
  end
  
  # Habilita el módulo rewrite para WordPress
  execute 'enable-apache-rewrite' do
    command 'a2enmod rewrite'
    notifies :restart, 'service[apache2]', :immediately
    not_if 'a2query -m rewrite'
  end