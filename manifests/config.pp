# Class to configure flink.
#
# Dont include this class directly.
#
class flink::config {
  if $::flink::manage_config {
    file { 'flink-conf.yaml':
      path    => "${::flink::install_dir}/conf/flink-conf.yaml",
      content => template('flink/flink-conf.yaml.erb'),
      mode    => '0755',
    }

    if $::flink::manage_service {
      File['flink-conf.yaml'] {
        notify  => Service[$::flink::service_name],
      }
    }

    if $::flink::manage_user {
      File['flink-conf.yaml'] {
        group   => $::flink::group,
        owner   => $::flink::user,
        require => [Group[$::flink::group],User[$::flink::user]],
      }
    }
  }
}