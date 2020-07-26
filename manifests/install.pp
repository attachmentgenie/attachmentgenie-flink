# Class to install flink.
#
# Dont include this class directly.
#
class flink::install {
  if $::flink::manage_user {
    user { 'flink':
      ensure => present,
      home   => $::flink::install_dir,
      name   => $::flink::user,
    }
    group { 'flink':
      ensure => present,
      name   => $::flink::group
    }
  }
  case $::flink::install_method {
    'package': {
      package { 'flink':
        ensure => $::flink::package_version,
        name   => $::flink::package_name,
      }
    }
    'archive': {
      file { 'flink install dir':
        ensure => directory,
        group  => $::flink::group,
        owner  => $::flink::user,
        path   => $::flink::install_dir,
      }
      if $::flink::manage_user {
        File[$::flink::install_dir] {
          require => [Group['flink'],User['flink']],
        }
      }

      archive { 'flink archive':
        cleanup         => true,
        creates         => "${::flink::install_dir}/bin",
        extract         => true,
        extract_command => 'tar -zxvf %s --strip-components=1',
        extract_path    => $::flink::install_dir,
        path            => '/tmp/flink.tgz',
        source          => $::flink::archive_source,
        user            => $::flink::user,
        group           => $::flink::group,
        require         => File['flink install dir']
      }

    }
    default: {
      fail("Installation method ${::flink::install_method} not supported")
    }
  }
}
