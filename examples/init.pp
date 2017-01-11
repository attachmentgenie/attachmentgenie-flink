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
class { '::java': } ->
class { '::flink':
  archive_source => 'http://apache.xl-mirror.nl/flink/flink-1.1.4/flink-1.1.4-bin-hadoop27-scala_2.11.tgz',
  install_method => 'archive',
}
