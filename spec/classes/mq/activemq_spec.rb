require 'spec_helper'
describe 'profiles::mq::activemq' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      context 'with defaults for all parameters' do
        it { is_expected.to contain_class('profiles::mq::activemq') }
        it { is_expected.to contain_file('/usr/share/activemq/activemq-data').with_ensure('link') }
      end
    end
  end
end
