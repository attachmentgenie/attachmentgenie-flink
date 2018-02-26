# The baseline for module testing used by Puppet Labs is that each manifest
# should have a corresponding test manifest that declares that class or defined
# type.
#
# Tests are then run by using puppet apply --noop (to check for compilation
# errors and view a log of events) or by fully applying the test in a virtual
# environment (to compare the resulting system state to the desired state).
#
# Learn more about module testing here:
# http://docs.puppetlabs.com/guides/tests_smoke.html
#
case $::osfamily {
  'RedHat': {
    $group = 'root'
    $package_name = 'java-1.8.0-openjdk'
    $package_options = undef
  }
  'Debian': {
    case $::operatingsystemrelease {
      /^8\..*/ : {
        $group = 'adm'
        $package_name = 'openjdk-8-jdk'
        $package_options = ['-t', 'jessie-backports']

        apt::source { 'jessie-backports':
          location => 'http://httpredir.debian.org/debian',
          release  => 'jessie-backports',
          repos    => 'main',
          key      => {
            'id'     => 'C2518248EEA14886',
            'server' => 'pgpkeys.mit.edu',
          },
        }

        Class['apt::update'] -> Package <| |>
        Apt::Source['jessie-backports'] -> Package['java']
      }
      /^14\.04.*/ : {
        $group = 'adm'
        $package_name = 'oracle-java8-installer'
        $package_options = undef

        apt::source { 'webupd8team':
          location => 'http://ppa.launchpad.net/webupd8team/java/ubuntu',
          release  => 'trusty',
          repos    => 'main',
          key      => {
            'id'     => 'C2518248EEA14886',
            'server' => 'keyserver.ubuntu.com',
          },
        }

        exec {'accept-license':
          command => '/bin/echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections'
        }

        Class['apt::update'] -> Package <| |>
        Apt::Source['webupd8team'] -> Package['java']
        Exec['accept-license'] -> Package['java']
      }
      default : {
        $group = 'root'
        $package_name = 'openjdk-8-jdk'
        $package_options = undef
      }
    }
  }
  default: {
    fail( "Unsupported OS family: ${::osfamily}" )
  }
}

class { '::java':
  distribution    => 'jdk',
  package         => $package_name,
  package_options => $package_options,
}
-> class { '::flink':
  archive_source => 'http://mirrors.supportex.net/apache/flink/flink-1.4.1/flink-1.4.1-bin-scala_2.11.tgz',
  install_method => 'archive',
}
