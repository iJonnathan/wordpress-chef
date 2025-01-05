# **Proyecto Chef-Vagrant: Despliegue Automático de WordPress**

Este proyecto utiliza Vagrant y Chef para configurar y desplegar automáticamente un servidor WordPress en una máquina virtual basada en Ubuntu. Incluye la instalación y configuración de Apache, MySQL, PHP y WordPress, además de pruebas automatizadas con ChefSpec y Test Kitchen.

## **Comandos**

### Clonar repo:

git clone <URL_DEL_REPOSITORIO> 


cd /wordpress-chef 

### Ejecutar VM: 

vagrant up

### Ejecutar UNIT_TEST: 

chef exec rspec cookbooks/wordpress/spec/unit/recipes/default_spec.rb

### Ejecutar INTEGRATION_TEST: 

?