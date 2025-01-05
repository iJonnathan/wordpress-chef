Vagrant.configure("2") do |config|
    config.vm.box = "bento/ubuntu-22.04"
    #box macM1
    #config.vm.box = "net9/ubuntu-24.04-arm64"
    config.vm.network "forwarded_port", guest: 80, host: 8080
    config.vm.network "private_network", ip: "192.168.56.99"
    
    config.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
      vb.cpus = 2
    end
    
    config.vm.provision "chef_zero" do |chef|
        chef.cookbooks_path = "./cookbooks"  # Define la ruta donde están los cookbooks
        chef.nodes_path = "./nodes"         # Ruta para los nodos
        chef.add_recipe "wordpress"         # Aplica la receta principal de WordPress
        chef.arguments = "--chef-license accept"  # Acepta la licencia
    end
    
  end
  