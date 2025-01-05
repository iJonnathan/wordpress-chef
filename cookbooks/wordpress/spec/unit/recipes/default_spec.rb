require 'chefspec'

# Pruebas unitarias para la receta 'wordpress::default'
describe 'wordpress::default' do
  before do
    # Stub del comando para verificar si el módulo mod_rewrite de Apache está habilitado
    stub_command("a2query -m rewrite").and_return(true)

    # Stub del comando para verificar si la base de datos de WordPress ya existe
    stub_command("mysql -u root -e 'SHOW DATABASES;' | grep wordpress").and_return(false)

    # Stub del comando para verificar si WordPress ya está instalado
    stub_command("wp core is-installed --path=/var/www/html --allow-root").and_return(false)
  end

  # Crea un entorno de prueba ChefSpec para Ubuntu 24.04
  let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '24.04').converge(described_recipe) }

  # Caso de prueba: Verificar que el paquete Apache2 está instalado
  # Propósito: Validar que el servidor web esté instalado como una dependencia de WordPress
  it 'instala apache2' do
    puts "[INFO] Verificando la instalación del paquete apache2"
    expect(chef_run).to install_package('apache2')
  end

  # Caso de prueba: Verificar que el servicio Apache2 está iniciado
  # Propósito: Comprobar que el servidor web está en ejecución y puede manejar solicitudes
  it 'inicia el servicio apache2' do
    puts "[INFO] Verificando que el servicio apache2 está iniciado"
    expect(chef_run).to start_service('apache2')
  end

  # Caso de prueba: Verificar que la base de datos de WordPress es creada
  # Propósito: Confirmar que la base de datos requerida para WordPress se inicializa correctamente
  it 'crea la base de datos de WordPress' do
    puts "[INFO] Verificando la creación de la base de datos de WordPress"
    expect(chef_run).to run_execute('create-database')
  end

  # Caso de prueba: Verificar que se incluye la receta Apache
  # Propósito: Comprobar que la receta 'wordpress::apache' se llama desde la receta principal
  it 'incluye la receta apache' do
    puts "[INFO] Verificando la inclusión de la receta apache"
    expect(chef_run).to include_recipe('wordpress::apache')
  end

  # Caso de prueba: Verificar que el archivo wp-config.php se crea con los permisos correctos
  # Propósito: Validar que el archivo de configuración de WordPress se genera correctamente y está protegido
  it 'crea el archivo wp-config.php con los permisos correctos' do
    puts "[INFO] Verificando la creación del archivo wp-config.php"
    expect(chef_run).to create_template('/var/www/html/wp-config.php').with(
      owner: 'www-data',
      group: 'www-data',
      mode: '0644'
    )
  end
end