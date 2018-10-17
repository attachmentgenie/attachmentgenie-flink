require 'spec_helper'
describe 'flink' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      context 'config' do
        context 'with manage_config set to true' do
          context 'with flink_config set to { foo => bar }' do
            let(:params) do
              {
                flink_config: { 'foo' => 'bar' },
                manage_config: true,
              }
            end

            it { is_expected.to contain_file('flink-conf.yaml').with_content(%r{foo:\sbar$}) }
          end

          context 'with install_dir set to /opt/special' do
            let(:params) do
              {
                install_dir: '/opt/special',
                manage_config: true,
              }
            end

            it { is_expected.to contain_file('flink-conf.yaml').with_path('/opt/special/conf/flink-conf.yaml') }
          end

          context 'with manage_service set to true' do
            let(:params) do
              {
                manage_config: true,
                manage_service: true,
                service_name: 'flink',
              }
            end

            it { is_expected.to contain_file('flink-conf.yaml').that_notifies('Service[flink]') }
          end

          context 'with manage_service set to false' do
            let(:params) do
              {
                manage_config: true,
                manage_service: false,
                service_name: 'flink',
              }
            end

            it { is_expected.not_to contain_file('flink-conf.yaml').that_notifies('Service[flink]') }
          end

          context 'with group set to myspecialgroup and manage_user set to true' do
            let(:params) do
              {
                group: 'myspecialgroup',
                install_dir: '/opt/flink',
                install_method: 'package',
                manage_config: true,
                manage_user: true,
              }
            end

            it { is_expected.to contain_file('flink-conf.yaml').with_group('myspecialgroup').that_requires('Group[myspecialgroup]') }
          end

          context 'with group set to myspecialgroup and manage_user set to false' do
            let(:params) do
              {
                group: 'myspecialgroup',
                install_dir: '/opt/flink',
                install_method: 'package',
                manage_config: true,
                manage_user: false,
              }
            end

            it { is_expected.not_to contain_file('flink-conf.yaml').with_group('myspecialgroup').that_requires('Group[myspecialgroup]') }
          end

          context 'with user set to myspecialuser and manage_user set to true' do
            let(:params) do
              {
                install_dir: '/opt/flink',
                install_method: 'package',
                manage_config: true,
                manage_user: true,
                user: 'myspecialuser',
              }
            end

            it { is_expected.to contain_file('flink-conf.yaml').with_owner('myspecialuser').that_requires('User[myspecialuser]') }
          end

          context 'with user set to myspecialuser and manage_user set to false' do
            let(:params) do
              {
                install_dir: '/opt/flink',
                install_method: 'package',
                manage_config: true,
                manage_user: false,
                user: 'myspecialuser',
              }
            end

            it { is_expected.not_to contain_file('flink-conf.yaml').with_owner('myspecialuser').that_requires('User[myspecialuser]') }
          end
        end

        context 'with manage_config set to false' do
          let(:params) do
            {
              manage_config: false,
            }
          end

          it { is_expected.not_to contain_file('flink-conf.yaml') }
        end
      end
    end
  end
end
