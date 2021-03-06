class apache ($hostname, $documentRoot) {
    # Install apache
    package { "apache2":
        ensure => latest,
        require => Exec['apt-get update']
    }

    # Change user / group
    exec { "apache2-change-user" :
        command => "echo 'User vagrant' >> /etc/apache2/httpd.conf",
        unless  => "grep -c 'User vagrant' /etc/apache2/httpd.conf",
        require => Package["apache2"],
        notify  => Service['apache2'],
    }

    # Enable the apache service
    service { "apache2":
        enable => true,
        ensure => running,
        require => Package["apache2"],
        subscribe => [
            File["/etc/apache2/mods-enabled/rewrite.load"],
            File["/etc/apache2/sites-enabled/010-project"]
        ]
    }

    # ensures that mod_rewrite is loaded and modifies the default configuration file
    file { "/etc/apache2/mods-enabled/rewrite.load":
        ensure => link,
        target => "/etc/apache2/mods-available/rewrite.load",
        require => Package['apache2'],
    }

    # Set the configuration
    file { "/etc/apache2/sites-enabled/010-project":
        ensure => present,
        source => "puppet:///modules/apache/project_vhost.conf",
        replace => false,
        require => Package['apache2'],
    }

    # Set the hostname
    exec { "apache.hostname":
        command => "echo \"ServerName localhost\" >> /etc/apache2/httpd.conf",
        unless => "grep ServerName /etc/apache2/httpd.conf",
        require => Package['apache2'],
        notify  => Service["apache2"]
    }
    exec { "apache.project.hostname":
        command => "sed -i 's/ServerName __HOSTNAME__/ServerName $hostname/' /etc/apache2/sites-enabled/010-project",
        onlyif => "grep \"ServerName __HOSTNAME__\" /etc/apache2/sites-enabled/010-project",
        require => File['/etc/apache2/sites-enabled/010-project']
    }
    exec { "apache.project.documentRoot":
        command => "sed -i s#__DOCUMENTROOT__#$documentRoot#g /etc/apache2/sites-enabled/010-project",
        require => File['/etc/apache2/sites-enabled/010-project']
    }

    # Remove the default index file
    file { "/var/www/index.html":
        ensure => absent,
        require => Package['apache2']
    }
}
