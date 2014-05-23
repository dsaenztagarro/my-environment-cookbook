#
# Cookbook Name:: my_environment
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

home_dir = "/home/vagrant"
development_dir = "#{home_dir}/Development"
projects_dir = "#{development_dir}/projects"

include_recipe 'apt'
include_recipe 'vim'
include_recipe 'git'

git "clone dotfiles" do
  repository "git@github.com:dsaenztagarro/dotfiles.git"
  reference "master"
  action :sync
  destination "#{node['my_environment']['projects_dir']}/dotfiles"
end

git "clone solarized" do
  repository "git@github.com:altercation/solarized.git"
  reference "master"
  action :sync
  destination "#{node['my_environment']['projects_dir']}/solarized"
end

directory projects_dir do
  owner 'vagrant'
  group 'vagrant'
  recursive true
end

git "clone vundle.vim" do
  repository "git@github.com:gmarik/Vundle.vim.git"
  reference "master"
  action :sync
  destination "#{node['my_environment']['home_dir']}/.vim/bundle/Vundle.vim"
end

execute "install_vim_plugins" do
  command "vim +BundleInstall +qall!"
end
