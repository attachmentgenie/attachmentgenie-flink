require 'spec_helper'
describe 'flink' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      context "service" do

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
end
