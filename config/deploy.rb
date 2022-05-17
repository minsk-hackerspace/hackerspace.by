require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
# require 'mina/rbenv'  # for rbenv support. (http://rbenv.org)
require 'mina/rvm' # for rvm support. (http://rvm.io)
require './config/deploy/mina-whenever/tasks.rb'

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

set :domain, '31.24.92.99'
set :user, 'user' # Username in the server to SSH to.
set :repo_port, '22' # SSH port number.

set :deploy_to, "/home/#{fetch(:user)}/hackerspace.by"
set :repository, 'https://github.com/minsk-hackerspace/hackerspace.by'
set :branch, 'master'

set :rvm_path, '/usr/local/rvm/scripts/rvm'

# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.
# They will be linked in the 'deploy:link_shared_paths' step.
#set :shared_paths, ['config/database.yml', 'config/secrets.yml', 'log']
set :shared_files, fetch(:shared_files, []).push('config/database.yml', 'config/secrets.yml')
set :shared_dirs, fetch(:shared_dirs, []).push('log', 'storage')

# Optional settings:
#   set :forward_agent, true     # SSH forward_agent.

# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
task :setup do
  command %[mkdir -p "#{fetch(:shared_path)}/log"]
  command %[chmod g+rx,u+rwx "#{fetch(:shared_path)}/log"]

  command %[mkdir -p "#{fetch(:shared_path)}/storage"]
  command %[chmod g+rx,u+rwx "#{fetch(:shared_path)}/storage"]

  command %[mkdir -p "#{fetch(:shared_path)}/config"]
  command %[chmod g+rx,u+rwx "#{fetch(:shared_path)}/config"]

  command %[mkdir -p "#{fetch(:shared_path)}/system"]
  command %[chmod g+rx,u+rwx "#{fetch(:shared_path)}/system"]

  command %[touch "#{fetch(:shared_path)}/config/database.yml"]
  command %[touch "#{fetch(:shared_path)}/config/secrets.yml"]
  command  %[echo "-----> Be sure to edit '#{fetch(:shared_path)}/config/database.yml' and 'secrets.yml'."]

  command %[ln -s /var/log/nginx/error.log "#{fetch(:shared_path)}/log/nginx_error.log"]
  command %[ln -s /var/log/nginx/access.log "#{fetch(:shared_path)}/log/nginx_access.log"]
  command %[ln -s "#{fetch(:current_path)}"]
  command %[ln -s "#{fetch(:shared_path)}/log"]

  if fetch(:repository)
    repo_host = fetch(:repository).split(%r{@|://}).last.split(%r{:|\/}).first
    repo_port = /:([0-9]+)/.match(fetch(:repository)) && /:([0-9]+)/.match(fetch(:repository))[1] || '22'

    command %[
      if ! ssh-keygen -H  -F #{fetch(:repo_host)} &>/dev/null; then
        ssh-keyscan -t rsa -p #{fetch(:repo_port)} -H #{fetch(:repo_host)} >> ~/.ssh/known_hosts
      fi
    ]
  end
end

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :remote_environment do
  invoke :'rvm:use', 'ruby-3.1.2'
end

desc 'Deploys the current version to the server.'
task :deploy do
  on :before_hook do
    # Put things to run locally before ssh
  end
  deploy do
    command 'echo $PATH'
    command 'echo $GEM_HOME'
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    on :launch do
      # command "cp -f #{fetch(:deploy_to)}/#{fetch(:current_path)}/config/nginx/hackerspace.by.conf /etc/nginx/sites-available/hackerspace.by.conf"
      # command 'ln -s /etc/nginx/sites-available/hackerspace.by.conf /etc/nginx/sites-enabled/hackerspace.by.conf'
      # command "mkdir -p /home/#{fetch(:user)}/.config/systemd/user"
      # command "cp -f #{fetch(:current_path)}/config/services/* /home/#{fetch(:user)}/.config/systemd/user"
      # command %{systemctl --user start gollum}
      command "rm -rf #{fetch(:current_path)}/public/system/"
      command "ln -s #{fetch(:shared_path)}/system/ #{fetch(:current_path)}/public/system"
      invoke :'whenever:update'
      invoke :restart
    end
  end
end

task :start do
  invoke :cd
  invoke :copy_configs
  invoke :nginx_restart
  invoke :puma_start
end

task :restart do
  invoke :cd
  invoke :copy_configs
  invoke :nginx_restart
  invoke :puma_restart

end

task :stop do
  invoke :cd
  invoke :copy_configs
  invoke :nginx_restart
  invoke :puma_stop
end

task :cd do
  command "cd #{fetch(:current_path)}"
end

task :reboot do
  command 'sudo reboot'
end

task :puma_start => :remote_environment do
  invoke :cd
  command %{systemctl --user start puma}
end

task :copy_configs => :remote_environment do
  command "sudo cp -f #{fetch(:current_path)}/config/nginx/hackerspace.by.conf /etc/nginx/sites-available/hackerspace.by"
end

task :puma_stop => :remote_environment do
  invoke :cd
  command %{systemctl --user stop puma}
end

task :puma_restart => :remote_environment do
  # command 'echo $PATH'
  # command 'echo $GEM_HOME'
  command %{systemctl --user restart puma}
end

task :nginx_restart => :remote_environment do
  command 'sudo service nginx restart'
end

desc 'Shows logs.'
task :logs do
  command %[cd #{fetch(:deploy_to)}/current && tail -f log/production.log]
end

# For help in making your deploy script, see the Mina documentation:
#
#  - http://nadarei.co/mina
#  - http://nadarei.co/mina/tasks
#  - http://nadarei.co/mina/settings
#  - http://nadarei.co/mina/helpers
