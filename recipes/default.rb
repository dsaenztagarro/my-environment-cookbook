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

# Command depends on running provision through shell command: rake vagrant
execute "copy_ssh_credentials" do
  command <<-EOH
    mkdir -p -v /root/.ssh
    cp -f -v /vagrant/tmp/id_rsa.pub /root/.ssh/authorized_keys
    cp -f -v /vagrant/tmp/known_hosts /root/.ssh/known_hosts
    cp -f -v /vagrant/tmp/id_rsa.pub /home/vagrant/.ssh/authorized_keys
    cp -f -v /vagrant/tmp/known_hosts /home/vagrant/.ssh/known_hosts
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

execute "git_config" do
  command <<-EOH
    git config --global user.name "dsaenztagarro"
    git config --global user.email david.saenz.tagarro@gmail.com
    git config --global core.editor "vim"
  EOH
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

execute "install_devtools" do
  command <<-EOH
    apt-get install tmux -y
    apt-get install exuberant-ctags -y
    apt-get install unzip -y
    apt-get install curl -y
  EOH
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
