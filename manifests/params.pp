# Class to manage flink parameters.
#
# Dont include this class directly.
#
class flink::params () {
  $archive_source  = undef
  $flink_config    = {
    'jobmanager.rpc.address' => 'localhost',
    'jobmanager.rpc.port' => 6123,
    'jobmanager.heap.mb' => 256,
    'taskmanager.heap.mb' => 512,
    'taskmanager.numberOfTaskSlots' => 1,
    'taskmanager.memory.preallocate' => false,
    'parallelism.default' => 1,
    'jobmanager.web.port' => 8081,
  }
  $group           = 'flink'
  $install_dir     = '/opt/flink'
  $install_method  = 'package'
  $manage_config = true
  $manage_service  = true
  $manage_user     = true
  $package_name    = 'flink'
  $package_version = 'present'
  $service_name    = 'flink'
  $service_ensure  = 'running'
  $user            = 'flink'
  case $::osfamily {
    'Debian': {
      case $::operatingsystemrelease {
        /(^7.*|^14\.04.*)/ : {
          $service_provider = 'debian'
        }
        default : {
          $service_provider = 'systemd'
        }
      }
    }
    'RedHat': {
      case $::operatingsystemrelease {
        /^6.*/ : {
          $service_provider = 'redhat'
        }
        default : {
          $service_provider = 'systemd'
        }
      }
    }
    default: {
      fail("Unsupported osfamily ${::osfamily}, currently only supports Debian and RedHat")
    }
  }
}