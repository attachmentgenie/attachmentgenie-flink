require 'spec_helper'
describe 'flink' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      context 'with defaults for all parameters' do
        it { is_expected.to contain_class('flink') }
        it { is_expected.to contain_class('flink::params') }
        it { is_expected.to contain_anchor('flink::begin').that_comes_before('Class[flink::Install]') }
        it { is_expected.to contain_class('flink::install').that_comes_before('Class[flink::Config]') }
        it { is_expected.to contain_class('flink::config').that_notifies('Class[flink::Service]') }
        it { is_expected.to contain_class('flink::service').that_comes_before('Anchor[flink::end]') }
        it { is_expected.to contain_anchor('flink::end') }
        it { is_expected.to contain_group('flink') }
        it { is_expected.to contain_package('flink') }
        it { is_expected.to contain_service('flink') }
        it { is_expected.to contain_user('flink') }
      end
    end
  end
end
