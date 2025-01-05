package 'mysql-server' do
  action :install
end

service 'mysql' do
  action [:enable, :start]
end

# Configuracion del usuario y contraseña root y la autenticación mysql_native_password
execute 'configure-mysql-root-authentication' do
  command <<-EOH
    sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '';" &&
    sudo mysql -e "FLUSH PRIVILEGES;"
  EOH
  action :run
end


# Se crea la base de datos 'wordpress'
execute 'create-database' do
  command "mysql -u root -e 'CREATE DATABASE #{node['wordpress']['db_name']}';"
  not_if "mysql -u root -e 'SHOW DATABASES;' | grep #{node['wordpress']['db_name']}"
end