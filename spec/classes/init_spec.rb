require 'spec_helper'
describe 'flink' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      context "init" do

        context 'with defaults for all parameters' do
          it { should contain_class('flink') }
          it { should contain_anchor('flink::begin').that_comes_before('Class[flink::Install]') }
          it { should contain_class('flink::install').that_comes_before('Class[flink::Config]') }
          it { should contain_class('flink::config').that_notifies('Class[flink::Service]') }
          it { should contain_class('flink::service').that_comes_before('Anchor[flink::end]') }
          it { should contain_anchor('flink::end') }
          it { should contain_file('flink-conf.yaml') }
          it { should contain_group('flink') }
          it { should contain_package('flink') }
          it { should contain_service('flink') }
          it { should contain_user('flink') }
        end

      end
    end
  end
end
