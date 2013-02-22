class symfony ($projectName, $symfonyVersion) {

	$web_path	 	 = '/vagrant/web'
	$target_dir      = '/usr/local/bin'
  	$composer_file   = 'composer'


	# Download and install install
	exec { 'download-composer':
		command     => 'curl -s http://getcomposer.org/installer | php',
		cwd         => $web_path,
		require     => Package['apache2', 'curl', "php5-curl"],
    }

	# Move file to target_dir
	/*
	file { 'move-composer':
		path 		=> "$target_dir/$composer_file",
		replace 	=> "yes", 
	    owner  		=> root,
	    group  		=> root,
	    mode   		=> 0755,
		ensure      => present,
		source      => "$web_path/composer.phar",
		require     => Exec['download-composer'],
	}
	file { "$web_path/composer.phar": 
		ensure  	=> absent,
		require     => [Exec['download-composer'], File['move-composer'], ],
	}
	*/

	# run composer self-update
	exec { 'update-composer':
		command     => "php composer.phar self-update",
		cwd 		=> "$web_path/",
		require     => Exec['download-composer'],
	}

	# Install Symfony
	exec { 'install-symfony':
		command     => "sudo COMPOSER_PROCESS_TIMEOUT=4000 php composer.phar create-project symfony/framework-standard-edition $web_path/$projectName $symfonyVersion",
		cwd 		=> "$web_path/",
		timeout   	=> 0,
		creates 	=> "$web_path/$projectName/",
		# onlyif 		=> "test ! -d $web_path/$projectName/",
		require     => Exec['update-composer'],
		logoutput 	=> true,
	}

	# Create database
	exec { "create-symfony-database":
        command => "mysql -uroot -proot -e \"CREATE DATABASE IF NOT EXISTS $projectName;\"",
        require =>  [Package['apache2', 'phpmyadmin'], Service["mysql"], ],
    }

    # Allow local ip in app_dev.php
    exec { "Allowing 192.168.33.1 into web/app_dev.php":
		command 	=> 'sed -i "s/\(fe80::1\)/192.168.33.1/" web/app_dev.php',
		cwd 		=> "$web_path/$projectName/",
		require     => Exec['install-symfony'],
		onlyif 		=> "test -e $web_path/$projectName/web/app_dev.php",
    }

    # Allow local ip in config.php
    exec { "Allowing 192.168.33.1 into web/config.php":
		command 	=> 'sed -i "s/\(::1\)/192.168.33.1/" web/config.php',
		cwd 		=> "$web_path/$projectName/",
		require     => Exec['install-symfony'],
		onlyif 		=> "test -e $web_path/$projectName/web/config.php",
    }

    # Active Permission
    exec { "permission-1":
		command 	=> 'setfacl -R -m u:www-data:rwx app/cache app/logs',
		cwd 		=> "$web_path/$projectName/",
		require     => Exec['install-symfony'],
		onlyif 		=> "test -d $web_path/$projectName/app/cache",
    }

    # Active Permission
    exec { "permission-2":
		command 	=> 'setfacl -R -d -m u:www-data:rwx app/cache app/logs',
		cwd 		=> "$web_path/$projectName/",
		require     => Exec['install-symfony', 'permission-1'],
		onlyif 		=> "test -d $web_path/$projectName/app/cache",
    }

    # Active Permission
    exec { "permission-3":
		command 	=> 'setfacl -R -m u:vagrant:rwx app/cache app/logs',
		cwd 		=> "$web_path/$projectName/",
		require     => Exec['install-symfony', 'permission-2'],
		onlyif 		=> "test -d $web_path/$projectName/app/cache",
    }

    # Active Permission
    exec { "permission-4":
		command 	=> 'setfacl -R -d -m u:vagrant:rwx app/cache app/logs',
		cwd 		=> "$web_path/$projectName/",
		require     => Exec['install-symfony', 'permission-3'],
		onlyif 		=> "test -d $web_path/$projectName/app/cache",
    }

    # Active Permission
    exec { "permission-5":
		command 	=> 'setfacl -R -m mask:rwx app/cache app/logs',
		cwd 		=> "$web_path/$projectName/",
		require     => Exec['install-symfony', 'permission-4'],
		onlyif 		=> "test -d $web_path/$projectName/app/cache",
    }

    # Active Permission
    exec { "permission-6":
		command 	=> 'setfacl -R -d -m mask:rwx app/cache app/logs',
		cwd 		=> "$web_path/$projectName/",
		require     => Exec['install-symfony', 'permission-5'],
		onlyif 		=> "test -d $web_path/$projectName/app/cache",
    }
}