#
# Cookbook:: prometheus
# Recipe:: binary
#
# Author: Kristian Jarvenpaa <kristian.jarvenpaa@gmail.com>
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

include_recipe 'ark::default'

%w(curl tar bzip2).each do |pkg|
  package pkg
end

dir_name = ::File.basename(node['prometheus']['dir'])
dir_path = ::File.dirname(node['prometheus']['dir'])

tar_extract (node['prometheus']['binary_url']).to_s do
  checksum node['prometheus']['checksum']
  target_dir dir_path
  group node['prometheus']['group']
end

link '/opt/prometheus/prometheus' do
  to "/opt/prometheus-#{node['prometheus']['version']}.linux-amd64/prometheus"
  notifies :restart, 'service[prometheus]', :delayed
end
link '/opt/prometheus/consoles' do
  to "/opt/prometheus-#{node['prometheus']['version']}.linux-amd64/consoles"
  notifies :restart, 'service[prometheus]', :delayed
end
link '/opt/prometheus/console_libraries' do
  to "/opt/prometheus-#{node['prometheus']['version']}.linux-amd64/console_libraries"
  notifies :restart, 'service[prometheus]', :delayed
end
link '/opt/prometheus/promtool' do
  to "/opt/prometheus-#{node['prometheus']['version']}.linux-amd64/promtool"
end
link '/opt/prometheus/tsdb' do
  to "/opt/prometheus-#{node['prometheus']['version']}.linux-amd64/tsdb"
end

# ark dir_name do
#  url node['prometheus']['binary_url']
#  checksum node['prometheus']['checksum']
#  version node['prometheus']['version']
#  prefix_root Chef::Config['file_cache_path']
#  path dir_path
#  owner node['prometheus']['user']
#  group node['prometheus']['group']
#  extension node['prometheus']['file_extension'] unless node['prometheus']['file_extension'].empty?
#  action :put
# end
