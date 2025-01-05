package %w(php php-mysql libapache2-mod-php) do
  action :install
end

# Reiniciamos Apache para cargar los módulos PHP
service 'apache2' do
  action :restart
end