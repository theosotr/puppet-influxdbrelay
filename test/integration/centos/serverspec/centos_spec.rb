#
# Copyright (c) 2018 Richard Delaplace
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'spec_helper'

root_dirs = [
  '/opt/go',
  '/etc/influxdb-relay',
  '/opt/go/src/github.com/influxdata/influxdb-relay/'
]

influx_dirs = [
  '/var/lib/influxdb-relay',
  '/var/log/influxdb-relay'
]

links = [
  '/usr/lib/influxdb-relay',
  '/usr/bin/influxdb-relay',
  '/etc/logrotate.d/influxdb-relay'
]

describe 'Packages' do
  describe package('git') do
    it { should be_installed }
  end
  describe package('golang') do
    it { should be_installed }
  end
end

describe 'Directories' do
  root_dirs.each do |dir|
    describe file(dir) do
      it { should exist }
      it { should be_directory }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      it { should be_mode 755 }
    end
  end
  influx_dirs.each do |dir|
    describe file(dir) do
      it { should exist }
      it { should be_directory }
      it { should be_owned_by 'influxdb-relay' }
      it { should be_grouped_into 'influxdb-relay' }
      it { should be_mode 755 }
    end
  end
end

describe 'Links' do
  links.each do |link|
    describe file(link) do
      it { should exist }
      it { should be_symlink }
    end
  end
end

describe 'Files' do
  describe file('/etc/environment') do
    it { should exist }
    its(:content) { should contain 'GOPATH=/opt/go' }
  end
  describe file('/etc/influxdb-relay/influxdb-relay.conf') do
    it { should exist }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 644 }
    its(:content) do
      should contain \
        '### Files generated by Puppet, please do not edit manually'
    end
  end
end

describe 'Service' do
  describe service('influxdb-relay') do
    it { should be_enabled }
    it { should be_running }
  end
end