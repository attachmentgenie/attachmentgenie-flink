# Class to install and configure apache flink.
#
# Use this module to install and configure apache flink.
#
# @example Declaring the class
#   include ::flink
#
# @param archive_source (String) Location of flink binary release.
# @param flink_config (Hash) Flink configuration key-value pairs.
# @param group (String) Group that owns flink files.
# @param install_dir (String) Location of flink binary release.
# @param install_method (String) How to install flink.
# @param manage_config (Boolean) Manage the flink config.
# @param manage_service (Boolean) Manage the flink service.
# @param manage_user (Boolean) Manage flink user and group.
# @param package_name (String) Name of package to install.
# @param package_version (String) Version of flink to install.
# @param service_name (String) Name of service to manage.
# @param service_provider (String) init system that is used.
# @parama user (String) user that owns flink files.
class flink (
  $archive_source   = $::flink::params::archive_source,
  $flink_config     = $::flink::params::flink_config,
  $group            = $::flink::params::group,
  $install_dir      = $::flink::params::install_dir,
  $install_method   = $::flink::params::install_method,
  $manage_config    = $::flink::params::manage_config,
  $manage_service   = $::flink::params::manage_service,
  $manage_user      = $::flink::params::manage_user,
  $package_name     = $::flink::params::package_name,
  $package_version  = $::flink::params::package_version,
  $service_name     = $::flink::params::service_name,
  $service_provider = $::flink::params::service_provider,
  $user             = $::flink::params::user,
) inherits flink::params {
  validate_bool(
    $manage_config,
    $manage_service,
    $manage_user,
  )
  validate_hash(
    $flink_config,
  )
  if $install_method == 'archive' {
    validate_string(
      $archive_source
    )
  }
  validate_string(
    $group,
    $install_dir,
    $install_method,
    $package_name,
    $package_version,
    $service_name,
    $service_provider,
    $user,
  )

  anchor { 'flink::begin': } ->
  class{ '::flink::install': } ->
  class{ '::flink::config': } ~>
  class{ '::flink::service': } ->
  anchor { 'flink::end': }
}
