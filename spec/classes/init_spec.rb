require 'spec_helper'
describe 'flink' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      context 'with defaults for all parameters' do
        it { should contain_class('flink') }
        it { should contain_anchor('flink::begin').that_comes_before('Class[flink::Install]') }
        it { should contain_class('flink::install').that_comes_before('Class[flink::Config]') }
        it { should contain_class('flink::config').that_notifies('Class[flink::Service]') }
        it { should contain_class('flink::service').that_comes_before('Anchor[flink::end]') }
        it { should contain_anchor('flink::end') }
        it { should contain_group('flink') }
        it { should contain_package('flink') }
        it { should contain_service('flink') }
        it { should contain_user('flink') }
      end

      context 'with archive_source set to special.tar.gz' do
        let(:params) {
          {
              :archive_source => 'special.tar.gz',
              :install_method => 'archive'
          }
        }
        it { should contain_archive('/tmp/flink.tar.gz').with_source('special.tar.gz') }
      end

      context 'with group set to myspecialgroup' do
        let(:params) {
          {
              :group       => 'myspecialgroup',
              :manage_user => true,
          }
        }
        it { should contain_group('myspecialgroup') }
      end

      context 'with group set to myspecialgroup and install_method set to archive' do
        let(:params) {
          {
              :group          => 'myspecialgroup',
              :install_dir    => '/opt/flink',
              :install_method => 'archive',
              :manage_user    => true
          }
        }
        it { should contain_file('/opt/flink').with_group('myspecialgroup') }
        it { should contain_archive('/tmp/flink.tar.gz').with_group('myspecialgroup') }
      end

      context 'with group set to myspecialgroup and install_method set to archive and manage_user set to true' do
        let(:params) {
          {
              :group          => 'myspecialgroup',
              :install_dir    => '/opt/flink',
              :install_method => 'archive',
              :manage_user    => true
          }
        }
        it { should contain_file('/opt/flink').with_group('myspecialgroup').that_requires('Group[myspecialgroup]') }
        it { should contain_archive('/tmp/flink.tar.gz').with_group('myspecialgroup') }
      end

      context 'with group set to myspecialgroup and install_method set to archive and manage_user set to false' do
        let(:params) {
          {
              :group          => 'myspecialgroup',
              :install_dir    => '/opt/flink',
              :install_method => 'archive',
              :manage_user    => false
          }
        }
        it { should contain_file('/opt/flink').with_group('myspecialgroup').that_requires(nil) }
        it { should contain_archive('/tmp/flink.tar.gz').with_group('myspecialgroup') }
      end

      context 'with group set to myspecialgroup and service_provider set to debian' do
        let(:params) {
          {
              :group            => 'myspecialgroup',
              :install_dir      => '/opt/flink',
              :manage_service   => true,
              :manage_user      => true,
              :service_name     => 'flink',
              :service_provider => 'debian',
          }
        }
        it { should contain_file('/etc/init.d/flink').with_group('myspecialgroup') }
      end

      context 'with group set to myspecialgroup and service_provider set to init' do
        let(:params) {
          {
              :group            => 'myspecialgroup',
              :install_dir      => '/opt/flink',
              :manage_service   => true,
              :manage_user      => true,
              :service_name     => 'flink',
              :service_provider => 'init',
          }
        }
        it { should contain_file('/etc/init.d/flink').with_group('myspecialgroup') }
      end

      context 'with group set to myspecialgroup and service_provider set to redhat' do
        let(:params) {
          {
              :group            => 'myspecialgroup',
              :install_dir      => '/opt/flink',
              :manage_service   => true,
              :manage_user      => true,
              :service_name     => 'flink',
              :service_provider => 'redhat',
          }
        }
        it { should contain_file('/etc/init.d/flink').with_group('myspecialgroup') }
      end

      context 'with install_dir set to /opt/special' do
        let(:params) {
          {
              :install_dir    => '/opt/special',
              :install_method => 'archive'
          }
        }
        it { should contain_file('/opt/special')}
        it { should contain_archive('/tmp/flink.tar.gz').with_creates('/opt/special/bin') }
        it { should contain_archive('/tmp/flink.tar.gz').with_extract_path('/opt/special') }
        it { should contain_archive('/tmp/flink.tar.gz').that_requires('File[/opt/special]') }
      end

      context 'with install_dir set to /opt/special and manage_user set to true' do
        let(:params) {
          {
              :install_dir    => '/opt/special',
              :install_method => 'archive',
              :manage_user    => true,
              :user           => 'flink'
          }
        }
        it { should contain_user('flink').with_home('/opt/special') }
        it { should contain_file('/opt/special').that_requires('User[flink]') }
      end

      context 'with install_dir set to /opt/special and manage_service set to true and service_provider set to debian' do
        let(:params) {
          {
              :install_dir      => '/opt/special',
              :manage_service   => true,
              :service_name     => 'flink',
              :service_provider => 'debian'
          }
        }
        it { should contain_file('/etc/init.d/flink').with_content(/(^\/opt\/special\/bin\/.*$)+/) }
      end

      context 'with install_dir set to /opt/special and manage_service set to true and service_provider set to init' do
        let(:params) {
          {
              :install_dir      => '/opt/special',
              :manage_service   => true,
              :service_name     => 'flink',
              :service_provider => 'init'
          }
        }
        it { should contain_file('/etc/init.d/flink').with_content(/(^\/opt\/special\/bin\/.*$)+/) }
      end

      context 'with install_dir set to /opt/special and manage_service set to true and service_provider set to redhat' do
        let(:params) {
          {
              :install_dir      => '/opt/special',
              :manage_service   => true,
              :service_name     => 'flink',
              :service_provider => 'redhat'
          }
        }
        it { should contain_file('/etc/init.d/flink').with_content(/(^\/opt\/special\/bin\/.*$)+/) }
      end

      context 'with install_dir set to /opt/special and manage_service set to true and service_provider set to systemd' do
        let(:params) {
          {
              :install_dir      => '/opt/special',
              :manage_service   => true,
              :service_name     => 'flink',
              :service_provider => 'systemd'
          }
        }
        it { should contain_systemd__Unit_file('flink.service').with_content(/(\/opt\/special\/bin.*$)+/) }
      end

      context 'with install_method set to archive' do
        let(:params) {
          {
              :install_dir    => '/opt/flink',
              :install_method => 'archive',
              :package_name   => 'flink'
          }
        }
        it { should contain_file('/opt/flink').that_comes_before('Archive[/tmp/flink.tar.gz]') }
        it { should contain_archive('/tmp/flink.tar.gz') }
        it { should_not contain_package('flink') }
      end

      context 'with install_method set to package' do
        let(:params) {
          {
              :install_dir    => '/opt/flink',
              :install_method => 'package',
              :package_name   => 'flink'
          }
        }
        it { should_not contain_file('/opt/flink').that_comes_before('Archive[/tmp/flink.tar.gz]') }
        it { should_not contain_archive('/tmp/flink.tar.gz') }
        it { should contain_package('flink') }
      end

      context 'with install_method set to invalid' do
        let(:params) {
          {
              :install_method => 'invalid'
          }
        }
        it { should raise_error(/Installation method invalid not supported/) }
      end

      context 'with manage_service set to true' do
        let(:params) {
          {
              :manage_service => true,
              :service_name   => 'flink'
          }
        }
        it { should contain_service('flink') }
      end

      context 'with manage_service set to false' do
        let(:params) {
          {
              :manage_service => false,
              :service_name   => 'flink'
          }
        }
        it { should_not contain_service('flink') }
      end

      context 'with manage_user set to true' do
        let(:params) {
          {
              :group       => 'flink',
              :manage_user => true,
              :user        => 'flink'
          }
        }
        it { should contain_user('flink') }
        it { should contain_group('flink') }
      end

      context 'with manage_user set to false' do
        let(:params) {
          {
              :manage_user => false
          }
        }
        it { should_not contain_user('flink') }
        it { should_not contain_group('flink') }
      end

      context 'with package_name set to specialpackage' do
        let(:params) {
          {
              :install_method => 'package',
              :package_name   => 'specialpackage',
          }
        }
        it { should contain_package('specialpackage') }
      end

      context 'with package_name set to specialpackage and manage_service set to true' do
        let(:params) {
          {
              :install_method => 'package',
              :manage_service => true,
              :package_name   => 'specialpackage',
              :service_name   => 'flink'
          }
        }
        it { should contain_package('specialpackage') }
        it { should contain_service('flink').that_subscribes_to('Package[specialpackage]') }
      end

      context 'with package_version set to 42.42.42' do
        let(:params) {
          {
              :install_method  => 'package',
              :package_name    => 'flink',
              :package_version => '42.42.42',
          }
        }
        it { should contain_package('flink').with_ensure('42.42.42') }
      end

      context 'with service_name set to specialservice' do
        let(:params) {
          {
              :manage_service => true,
              :service_name   => 'specialservice',
          }
        }
        it { should contain_service('specialservice') }
      end

      context 'with service_name set to specialservice and with service_provider set to debian' do
        let(:params) {
          {
              :manage_service   => true,
              :service_name     => 'specialservice',
              :service_provider => 'debian',
          }
        }
        it { should contain_service('specialservice') }
        it { should contain_file('/etc/init.d/specialservice').that_notifies('Service[specialservice]').with_content(/^NAME=specialservice/) }
      end

      context 'with service_name set to specialservice and with service_provider set to init' do
        let(:params) {
          {
              :manage_service   => true,
              :service_name     => 'specialservice',
              :service_provider => 'init',
          }
        }
        it { should contain_service('specialservice') }
        it { should contain_file('/etc/init.d/specialservice').that_notifies('Service[specialservice]').with_content(/^NAME=specialservice/) }
      end

      context 'with service_name set to specialservice and with service_provider set to redhat' do
        let(:params) {
          {
              :manage_service   => true,
              :service_name     => 'specialservice',
              :service_provider => 'redhat',
          }
        }
        it { should contain_service('specialservice') }
        it { should contain_file('/etc/init.d/specialservice').that_notifies('Service[specialservice]').with_content(/^NAME=specialservice/) }
      end

      context 'with service_name set to specialservice and with service_provider set to systemd' do
        let(:params) {
          {
              :manage_service   => true,
              :service_name     => 'specialservice',
              :service_provider => 'systemd',
          }
        }
        it { should contain_service('specialservice') }
        it { should contain_systemd__Unit_file('specialservice.service').that_comes_before('Service[specialservice]').with_content(/^Description=specialservice/) }
      end

      context 'with service_name set to specialservice and with install_method set to package' do
        let(:params) {
          {
              :install_method => 'package',
              :manage_service => true,
              :package_name   => 'flink',
              :service_name   => 'specialservice',
          }
        }
        it { should contain_service('specialservice').that_subscribes_to('Package[flink]') }
      end

      context 'with service_provider set to init' do
        let(:params) {
          {
              :manage_service   => true,
              :service_name     => 'flink',
              :service_provider => 'init',
          }
        }
        it { should contain_file('/etc/init.d/flink') }
        it { should_not contain_systemd__Unit_file('flink.service').that_comes_before('Service[flink]') }
        it { should contain_service('flink') }
      end

      context 'with service_provider set to systemd' do
        let(:params) {
          {
              :manage_service   => true,
              :service_name     => 'flink',
              :service_provider => 'systemd',
          }
        }
        it { should_not contain_file('/etc/init.d/flink') }
        it { should contain_systemd__Unit_file('flink.service').that_comes_before('Service[flink]') }
        it { should contain_service('flink') }
      end

      context 'with service_provider set to invalid' do
        let(:params) {
          {
              :manage_service   => true,
              :service_provider => 'invalid',
          }
        }
        it { should raise_error(/Service provider invalid not supported/) }
      end

      context 'with user set to myspecialuser' do
        let(:params) {
          {
              :manage_user => true,
              :user        => 'myspecialuser',
          }
        }
        it { should contain_user('myspecialuser') }
      end

      context 'with user set to myspecialuser and install_method set to archive' do
        let(:params) {
          {
              :install_dir    => '/opt/flink',
              :install_method => 'archive',
              :manage_user    => true,
              :user           => 'myspecialuser'
          }
        }
        it { should contain_file('/opt/flink').with_owner('myspecialuser') }
        it { should contain_archive('/tmp/flink.tar.gz').with_user('myspecialuser') }
      end

      context 'with user set to myspecialuser and install_method set to archive and manage_user set to true' do
        let(:params) {
          {
              :install_dir    => '/opt/flink',
              :install_method => 'archive',
              :manage_user    => true,
              :user           => 'myspecialuser'
          }
        }
        it { should contain_file('/opt/flink').with_owner('myspecialuser').that_requires('User[myspecialuser]') }
        it { should contain_archive('/tmp/flink.tar.gz').with_user('myspecialuser') }
      end

      context 'with user set to myspecialuser and install_method set to archive and manage_user set to false' do
        let(:params) {
          {
              :install_dir    => '/opt/flink',
              :install_method => 'archive',
              :manage_user    => false,
              :user           => 'myspecialuser'
          }
        }
        it { should contain_file('/opt/flink').with_owner('myspecialuser').that_requires(nil) }
        it { should contain_archive('/tmp/flink.tar.gz').with_user('myspecialuser') }
      end

      context 'with user set to myspecialuser and service_provider set to debian' do
        let(:params) {
          {
              :user             => 'myspecialuser',
              :install_dir      => '/opt/flink',
              :manage_user      => true,
              :manage_service   => true,
              :service_name     => 'flink',
              :service_provider => 'debian',
          }
        }
        it { should contain_file('/etc/init.d/flink').with_owner('myspecialuser') }
      end

      context 'with user set to myspecialuser and service_provider set to init' do
        let(:params) {
          {
              :user             => 'myspecialuser',
              :install_dir      => '/opt/flink',
              :manage_user      => true,
              :manage_service   => true,
              :service_name     => 'flink',
              :service_provider => 'init',
          }
        }
        it { should contain_file('/etc/init.d/flink').with_owner('myspecialuser') }
      end

      context 'with user set to myspecialuser and service_provider set to redhat' do
        let(:params) {
          {
              :user             => 'myspecialuser',
              :install_dir      => '/opt/flink',
              :manage_user      => true,
              :manage_service   => true,
              :service_name     => 'flink',
              :service_provider => 'redhat',
          }
        }
        it { should contain_file('/etc/init.d/flink').with_owner('myspecialuser') }
      end
    end
  end
end
