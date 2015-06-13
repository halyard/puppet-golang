require 'spec_helper'

describe 'golang' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "golang class without any parameters" do
          let(:params) {{ }}

          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('golang::params') }
          it { is_expected.to contain_class('golang::install').that_comes_before('golang::config') }
          it { is_expected.to contain_class('golang::config') }
          it { is_expected.to contain_class('golang::service').that_subscribes_to('golang::config') }

          it { is_expected.to contain_service('golang') }
          it { is_expected.to contain_package('golang').with_ensure('present') }
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'golang class without any parameters on Solaris/Nexenta' do
      let(:facts) {{
        :osfamily        => 'Solaris',
        :operatingsystem => 'Nexenta',
      }}

      it { expect { is_expected.to contain_package('golang') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
