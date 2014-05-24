home_path = '/home/vagrant'
development_path = "#{home_path}/Development"

default['my-environment']['home_path'] = home_path
default['my-environment']['development_path'] = "#{home_path}/Development"
default['my-environment']['projects_path'] = "#{development_path}/projects"
