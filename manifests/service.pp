# Class to manage the flink service.
#
# Dont include this class directly.
#
class flink::service {
  if $::flink::manage_service {
    case $::flink::service_provider {
      'debian','init','redhat': {
        file { 'flink service file':
          path    => "/etc/init.d/${::flink::service_name}",
          content => template('flink/flink.init.erb'),
          group   => $::flink::group,
          mode    => '0755',
          notify  => Service['flink'],
          owner   => $::flink::user,
        }
      }
      'systemd': {
        ::systemd::unit_file { "${::flink::service_name}.service":
          content => template('flink/flink.service.erb'),
          before  => Service['flink'],
        }
      }
      default: {
        fail("Service provider ${::flink::service_provider} not supported")
      }
    }

    case $::flink::install_method {
      'archive': {}
      'package': {
        Service['flink'] {
          subscribe => Package['flink'],
        }
      }
      default: {
        fail("Installation method ${::flink::install_method} not supported")
      }
    }

    service { 'flink':
      ensure   => $::flink::service_ensure,
      enable   => true,
      name     => $::flink::service_name,
      provider => $::flink::service_provider,
    }
  }
}
