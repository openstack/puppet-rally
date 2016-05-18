require 'spec_helper'

describe 'rally::db' do

  shared_examples 'rally::db' do
    context 'with default parameters' do
      it { is_expected.to contain_rally_config('database/connection').with_value('sqlite:////var/lib/rally/rally.sqlite') }
      it { is_expected.to contain_rally_config('database/idle_timeout').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_rally_config('database/min_pool_size').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_rally_config('database/max_retries').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_rally_config('database/retry_interval').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_rally_config('database/max_pool_size').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_rally_config('database/max_overflow').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_rally_config('database/db_max_retries').with_value('<SERVICE DEFAULT>') }

      it 'should create sqlite rally directory' do
        is_expected.to contain_file('/var/lib/rally').with(
          :ensure => 'directory',
          :owner  => 'root',
          :group  => 'root',
          :mode   => '0755',
          :path   => '/var/lib/rally',
        )
      end
    end


    context 'with specific parameters' do
      let :params do
        { :database_connection     => 'mysql://rally:rally@localhost/rally',
          :database_idle_timeout   => '3601',
          :database_min_pool_size  => '2',
          :database_max_retries    => '11',
          :database_retry_interval => '11',
          :database_max_pool_size  => '11',
          :database_max_overflow   => '21',
          :database_db_max_retries => '-1',
        }
      end

      it { is_expected.to contain_rally_config('database/connection').with_value('mysql://rally:rally@localhost/rally') }
      it { is_expected.to contain_rally_config('database/idle_timeout').with_value('3601') }
      it { is_expected.to contain_rally_config('database/min_pool_size').with_value('2') }
      it { is_expected.to contain_rally_config('database/max_retries').with_value('11') }
      it { is_expected.to contain_rally_config('database/retry_interval').with_value('11') }
      it { is_expected.to contain_rally_config('database/max_pool_size').with_value('11') }
      it { is_expected.to contain_rally_config('database/max_overflow').with_value('21') }
      it { is_expected.to contain_rally_config('database/db_max_retries').with_value('-1') }
      it 'should not create sqlite rally directory' do
        is_expected.to_not contain_file('create_sqlite_directory')
      end
    end

    context 'with postgresql backend' do
      let :params do
        { :database_connection     => 'postgresql://rally:rally@localhost/rally', }
      end

      it 'install the proper backend package' do
        is_expected.to contain_package('python-psycopg2').with(:ensure => 'present')
      end

    end

    context 'with incorrect database_connection string' do
      let :params do
        { :database_connection     => 'foodb://rally:rally@localhost/rally', }
      end

      it_raises 'a Puppet::Error', /validate_re/
    end
  end

  context 'on Debian platforms' do
    let :facts do
      @default_facts.merge({
        :osfamily => 'Debian',
        :operatingsystem => 'Debian',
        :operatingsystemrelease => 'jessie',
      })
    end

    it_configures 'rally::db'
  end

  context 'on Redhat platforms' do
    let :facts do
      @default_facts.merge({
        :osfamily => 'RedHat',
        :operatingsystemrelease => '7.1',
      })
    end

    it_configures 'rally::db'
  end

end
