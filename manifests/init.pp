# Class to install and configure apache flink.
#
# Use this module to install and configure apache flink.
#
# @example Declaring the class
#   include ::flink
#
# @param archive_source Location of flink binary release.
# @param flink_config Flink configuration key-value pairs.
# @param group Group that owns flink files.
# @param install_dir Location of flink binary release.
# @param install_method How to install flink.
# @param manage_config Manage the flink config file.
# @param manage_service Manage the flink service.
# @param manage_user Manage flink user and group.
# @param package_name Name of package to install.
# @param package_version Version of flink to install.
# @param service_name Name of service to manage.
# @param service_provider Init system that is used.
# @param service_ensure The state of the service.
# @param user User that owns flink files.
class flink (
  Optional[String] $archive_source = $::flink::params::archive_source,
  Hash $flink_config = $::flink::params::flink_config,
  String $group = $::flink::params::group,
  String $install_dir = $::flink::params::install_dir,
  Enum['archive','package'] $install_method = $::flink::params::install_method,
  Boolean $manage_config = $::flink::params::manage_config,
  Boolean $manage_service = $::flink::params::manage_service,
  Boolean $manage_user = $::flink::params::manage_user,
  String $package_name = $::flink::params::package_name,
  String $package_version = $::flink::params::package_version,
  String $service_name = $::flink::params::service_name,
  String $service_provider = $::flink::params::service_provider,
  Enum['running','stopped'] $service_ensure = $::flink::params::service_ensure,
  String $user = $::flink::params::user,
) inherits flink::params {
  anchor { 'flink::begin': }
  -> class{ '::flink::install': }
  -> class{ '::flink::config': }
  ~> class{ '::flink::service': }
  -> anchor { 'flink::end': }
}
