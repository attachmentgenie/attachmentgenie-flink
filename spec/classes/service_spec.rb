require 'spec_helper'
describe 'flink' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      context 'with group set to myspecialgroup and service_provider set to debian' do
        let(:params) do
          {
            group: 'myspecialgroup',
            install_dir: '/opt/flink',
            manage_service: true,
            manage_user: true,
            service_name: 'flink',
            service_provider: 'debian',
          }
        end

        it { is_expected.to contain_file('flink service file').with_group('myspecialgroup') }
      end

      context 'with group set to myspecialgroup and service_provider set to init' do
        let(:params) do
          {
            group: 'myspecialgroup',
            install_dir: '/opt/flink',
            manage_service: true,
            manage_user: true,
            service_name: 'flink',
            service_provider: 'init',
          }
        end

        it { is_expected.to contain_file('flink service file').with_group('myspecialgroup') }
      end

      context 'with group set to myspecialgroup and service_provider set to redhat' do
        let(:params) do
          {
            group: 'myspecialgroup',
            install_dir: '/opt/flink',
            manage_service: true,
            manage_user: true,
            service_name: 'flink',
            service_provider: 'redhat',
          }
        end

        it { is_expected.to contain_file('flink service file').with_group('myspecialgroup') }
      end

      context 'with install_dir set to /opt/special and manage_service set to true and service_provider set to debian' do
        let(:params) do
          {
            install_dir: '/opt/special',
            manage_service: true,
            service_name: 'flink',
            service_provider: 'debian',
          }
        end

        it { is_expected.to contain_file('flink service file').with_content(%r{^NAME=flink$}) }
      end

      context 'with install_dir set to /opt/special and manage_service set to true and service_provider set to init' do
        let(:params) do
          {
            install_dir: '/opt/special',
            manage_service: true,
            service_name: 'flink',
            service_provider: 'init',
          }
        end

        it { is_expected.to contain_file('flink service file').with_content(%r{^NAME=flink$}) }
      end

      context 'with install_dir set to /opt/special and manage_service set to true and service_provider set to redhat' do
        let(:params) do
          {
            install_dir: '/opt/special',
            manage_service: true,
            service_name: 'flink',
            service_provider: 'redhat',
          }
        end

        it { is_expected.to contain_file('flink service file').with_content(%r{^NAME=flink$}) }
      end

      context 'with install_dir set to /opt/special and manage_service set to true and service_provider set to systemd' do
        let(:params) do
          {
            install_dir: '/opt/special',
            manage_service: true,
            service_name: 'flink',
            service_provider: 'systemd',
          }
        end

        it { is_expected.to contain_systemd__Unit_file('flink.service').with_content(%r{^ExecStart=/opt/special/bin/start-local.sh}) }
      end

      context 'with manage_service set to true' do
        let(:params) do
          {
            manage_service: true,
            service_name: 'flink',
          }
        end

        it { is_expected.to contain_service('flink') }
      end

      context 'with manage_service set to false' do
        let(:params) do
          {
            manage_service: false,
            service_name: 'flink',
          }
        end

        it { is_expected.not_to contain_service('flink') }
      end

      context 'with package_name set to specialpackage and manage_service set to true' do
        let(:params) do
          {
            install_method: 'package',
            manage_service: true,
            package_name: 'specialpackage',
            service_name: 'flink',
          }
        end

        it { is_expected.to contain_package('flink').with_name('specialpackage') }
        it { is_expected.to contain_service('flink').that_subscribes_to('Package[specialpackage]') }
      end

      context 'with service_name set to specialservice' do
        let(:params) do
          {
            manage_service: true,
            service_name: 'specialservice',
          }
        end

        it { is_expected.to contain_service('flink').with_name('specialservice') }
      end

      context 'with service_name set to specialservice and with service_provider set to debian' do
        let(:params) do
          {
            manage_service: true,
            service_name: 'specialservice',
            service_provider: 'debian',
          }
        end

        it { is_expected.to contain_service('flink').with_name('specialservice') }
        it { is_expected.to contain_file('flink service file').with_path('/etc/init.d/specialservice').that_notifies('Service[flink]').with_content(%r{^NAME=specialservice}) }
      end

      context 'with service_name set to specialservice and with service_provider set to init' do
        let(:params) do
          {
            manage_service: true,
            service_name: 'specialservice',
            service_provider: 'init',
          }
        end

        it { is_expected.to contain_service('flink').with_name('specialservice') }
        it { is_expected.to contain_file('flink service file').with_path('/etc/init.d/specialservice').that_notifies('Service[flink]').with_content(%r{^NAME=specialservice}) }
      end

      context 'with service_name set to specialservice and with service_provider set to redhat' do
        let(:params) do
          {
            manage_service: true,
            service_name: 'specialservice',
            service_provider: 'redhat',
          }
        end

        it { is_expected.to contain_service('flink').with_name('specialservice') }
        it { is_expected.to contain_file('flink service file').with_path('/etc/init.d/specialservice').that_notifies('Service[flink]').with_content(%r{^NAME=specialservice}) }
      end

      context 'with service_name set to specialservice and with service_provider set to systemd' do
        let(:params) do
          {
            manage_service: true,
            service_name: 'specialservice',
            service_provider: 'systemd',
          }
        end

        it { is_expected.to contain_service('flink').with_name('specialservice') }
        it { is_expected.to contain_systemd__Unit_file('specialservice.service').that_comes_before('Service[flink]').with_content(%r{^Description=specialservice}) }
      end

      context 'with service_name set to specialservice and with install_method set to package' do
        let(:params) do
          {
            install_method: 'package',
            manage_service: true,
            package_name: 'flink',
            service_name: 'specialservice',
          }
        end

        it { is_expected.to contain_service('flink').with_name('specialservice').that_subscribes_to('Package[flink]') }
      end

      context 'with service_provider set to init' do
        let(:params) do
          {
            manage_service: true,
            service_name: 'flink',
            service_provider: 'init',
          }
        end

        it { is_expected.to contain_file('flink service file').with_path('/etc/init.d/flink') }
        it { is_expected.not_to contain_systemd__Unit_file('flink.service').that_comes_before('Service[flink]') }
        it { is_expected.to contain_service('flink') }
      end

      context 'with service_provider set to systemd' do
        let(:params) do
          {
            manage_service: true,
            service_name: 'flink',
            service_provider: 'systemd',
          }
        end

        it { is_expected.not_to contain_file('flink service file').with_path('/etc/init.d/flink') }
        it { is_expected.to contain_systemd__Unit_file('flink.service').that_comes_before('Service[flink]') }
        it { is_expected.to contain_service('flink') }
      end

      context 'with service_provider set to invalid' do
        let(:params) do
          {
            manage_service: true,
            service_provider: 'invalid',
          }
        end

        it { is_expected.to raise_error(%r{Service provider invalid not supported}) }
      end

      context 'with user set to myspecialuser and service_provider set to debian' do
        let(:params) do
          {
            user: 'myspecialuser',
            install_dir: '/opt/flink',
            manage_user: true,
            manage_service: true,
            service_name: 'flink',
            service_provider: 'debian',
          }
        end

        it { is_expected.to contain_file('flink service file').with_path('/etc/init.d/flink').with_owner('myspecialuser') }
      end

      context 'with user set to myspecialuser and service_provider set to init' do
        let(:params) do
          {
            user: 'myspecialuser',
            install_dir: '/opt/flink',
            manage_user: true,
            manage_service: true,
            service_name: 'flink',
            service_provider: 'init',
          }
        end

        it { is_expected.to contain_file('flink service file').with_path('/etc/init.d/flink').with_owner('myspecialuser') }
      end

      context 'with user set to myspecialuser and service_provider set to redhat' do
        let(:params) do
          {
            user: 'myspecialuser',
            install_dir: '/opt/flink',
            manage_user: true,
            manage_service: true,
            service_name: 'flink',
            service_provider: 'redhat',
          }
        end

        it { is_expected.to contain_file('flink service file').with_path('/etc/init.d/flink').with_owner('myspecialuser') }
      end
    end
  end
end
