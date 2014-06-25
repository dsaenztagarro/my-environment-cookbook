#
# Cookbook Name:: my-environment
# Recipe:: locales
#
# Copyright (C) 2014 David Saenz Tagarro
#
# All rights reserved - Do Not Redistribute
#

execute "config_locales" do
  command <<-EOH
    locale-gen en_US.UTF-8
    dpkg-reconfigure locales
  EOH
end
