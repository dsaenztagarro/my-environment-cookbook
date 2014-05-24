#
# Cookbook Name:: my-environment
# Recipe:: default
#
# Copyright (C) 2014 David Saenz Tagarro
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'apt'
include_recipe 'vim'
include_recipe 'git'

home_path = node['my-environment']['home_path']
projects_path = node['my-environment']['projects_path']
dotfiles_path = "#{projects_path}/dotfiles"

execute "copy_ssh_credentials" do
  command <<-EOH
    mkdir -p /root/.ssh
    cp /vagrant/conf/id_rsa.pub /root/.ssh/authorized_keys
    cp /vagrant/conf/known_hosts /root/.ssh/known_hosts
    cp /vagrant/conf/id_rsa.pub /home/vagrant/.ssh/authorized_keys
    cp /vagrant/conf/known_hosts /home/vagrant/.ssh/known_hosts
    /etc/init.d/ssh restart
  EOH
end

directory projects_path do
  owner 'vagrant'
  group 'vagrant'
  recursive true
end

git "clone dotfiles" do
  repository "git@github.com:dsaenztagarro/dotfiles.git"
  reference "master"
  action :sync
  destination dotfiles_path
end

git "clone solarized" do
  repository "git@github.com:altercation/solarized.git"
  reference "master"
  action :sync
  destination "#{projects_path}/solarized"
end

directory "#{home_path}/.vim/bundle" do
  owner 'vagrant'
  group 'vagrant'
  recursive true
end

git "clone vundle.vim" do
  repository "git@github.com:gmarik/Vundle.vim.git"
  reference "master"
  action :sync
  destination "#{home_path}/.vim/bundle/Vundle.vim"
end

execute "install_tmux" do
  command "apt-get install tmux -y"
end

execute "link_dotfiles" do
  command <<-EOH
    ln -s -f #{dotfiles_path}/vim/vimrc #{home_path}/.vimrc &&
    ln -s -f #{dotfiles_path}/git/gitconfig #{home_path}/.gitconfig &&
    ln -s -f #{dotfiles_path}/jshint/jshintrc #{home_path}/.jshintrc &&
    ln -s -f #{dotfiles_path}/hg/hgrc #{home_path}/.hgrc &&
    ln -s -f #{dotfiles_path}/tmux/tmux.conf #{home_path}/.tmux.conf
  EOH
end
