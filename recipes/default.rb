#
# Cookbook Name:: cens-web
# Recipe:: default
#
# Author: Steve Nolen <technolengy@gmail.com>
#
# Copyright (c) 2014.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# require chef-vault
chef_gem 'chef-vault'
require 'chef-vault'

# install/enable nginx
node.set['nginx']['default_site_enabled'] = false
node.set['nginx']['install_method'] = 'repo'
include_recipe 'nginx'

# SSL
%w(ohmage.org mobilizingcs.org).each do |d|
  item = ChefVault::Item.load('ssl', d)
  file "/etc/ssl/certs/#{d}.crt" do
    owner 'root'
    group 'root'
    mode '0777'
    content item['cert']
    notifies :reload, 'service[nginx]', :delayed
  end
  file "/etc/ssl/private/#{d}.key" do
    owner 'root'
    group 'root'
    mode '0600'
    content item['key']
    notifies :reload, 'service[nginx]', :delayed
  end
end

%w(analytics.ohmage.org dropbox.mobilizingcs.org apps.ohmage.org web.ohmage.org wiki.mobilizingcs.org wiki.ohmage.org www.mobilizingcs.org wiki.eqis.io play.ohmage.org).each do |site|
  template "/etc/nginx/sites-available/#{site}" do
    source "#{site}-nginx.conf.erb"
    mode '0755'
    variables(
      site: site
    )
    notifies :reload, 'service[nginx]', :delayed
  end
  nginx_site site do
    action :enable
  end
end
