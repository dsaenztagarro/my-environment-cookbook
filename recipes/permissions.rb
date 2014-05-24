#
# Cookbook Name:: my-environment
# Recipe:: permissions
#
# Copyright (C) 2014 David Saenz Tagarro
#
# All rights reserved - Do Not Redistribute
#

execute "change_permissions" do
  command "chown -R -f vagrant:vagrant #{node['my-environment']['development_path']}"
end
