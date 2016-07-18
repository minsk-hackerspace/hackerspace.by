require 'bundler/capistrano'
require 'capistrano/ext/multistage'
require 'rubygems'
require 'action_view'
require 'time'

set :stages, %w(staging production)

set :default_stage, 'staging'

set :application, 'hspace'

set :hspace_user, 'www-data'
set :hspace_group, 'www-data'

default_run_options[:pty] = true # Must be set for the password prompt from git to work
set :ssh_options, {
    forward_agent: true,
    auth_methods: %w(publickey password)
}
set :use_sudo, false

set :repository, 'git@github.com:minsk-hackerspace/hspace.git'
set :scm, 'git'
#set :scm_passphrase, 'PUTPASSWORDHERE'
set :scm_verbose, true
set :deploy_via, :remote_cache
#To do an initial deployment, specify 'cap <environment> deploy -S initial_deployment=true'
set :initial_deployment, fetch(:initial_deployment, false)

# role :web, 'vhost1074.dc1.co.us.compute.ihost.com', 'vhost1270.dc1.co.us.compute.ihost.com'

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end


namespace :deploy do
  %w(start stop).each do |action|
    desc "#{action} the Thin processes"

    task action.to_sym, :on_error => :continue do
      # we don't need to start or stop passenger
    end
  end

  task :restart, :on_error => :continue do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

namespace :db do
  task :db_config, :except => {:no_release => true}, :role => :app do
    run "cp -f ~/database.yml #{release_path}/config/database.yml"
  end
end

after 'deploy:finalize_update', 'db:db_config'

task :do_post_update_code_work do
  # install gems as needed in shared bundle folder instead of gemset
  run "cd #{release_path} && bundle install --without development test"
  run "cd #{release_path} && ln -s /home/hswebcam public/webcam"

  if initial_deployment
    #Note that mongo must be set up and configured before the initial deployment,
    #or this will not work.
    run "cd #{release_path} && RAILS_ENV=#{rails_env} #{rake} db:setup", :only => {:primary => true}
  else
    run "cd #{release_path} && RAILS_ENV=#{rails_env} #{rake} db:migrate", :only => {:primary => true}
  end
end

after 'deploy:update_code', :do_post_update_code_work

# ---------------------
# fancy deploy features
# ---------------------
class DeployHelper
  include ActionView::Helpers::DateHelper
end

before 'deploy', 'deploy:check_for_initial_deployment'

set :branch_reference, nil
set :fork_info, nil

namespace :deploy do
  #To do an initial deployment, specify 'cap <environment> deploy -S initial_deployment=true'
  task :check_for_initial_deployment do
    if initial_deployment
      puts "WARNING: You have requested an initial deployment.\n" \
           "If hspace is currently installed, the version installed will be removed.\n"
      ask_for_yes_no_input "Are you sure you want to proceed?"

      #Remove any existing code/directories.
      run "rm -rf #{deploy_to}/*"

      #Set up the directories, ensuring correct ownership. Also create
      #an initial REVISION file with an old, but valid, github tag.
      run "mkdir -p #{deploy_to}/releases/000"
      run "chown -R #{user}:#{hspace_group} #{deploy_to}"
      run "ln -s #{deploy_to}/releases/000 #{deploy_to}/current"
      run "echo 5e22b77e7f07d585ebe9a58eea927e3b280d0e11 > #{deploy_to}/current/REVISION"

      #Create and set proper ownership/permissions on these as well. Be sure to do
      #this AFTER the above.
      run "mkdir -p #{shared_path}"
      run "chown #{user}:#{hspace_group} #{shared_path}"
      run "mkdir -p -m 2775 #{shared_path}/log"
      run "mkdir -p -m 2775 #{shared_path}/pids"
      run "touch #{shared_path}/log/#{rails_env}.log"
      run "touch #{shared_path}/log/#{rails_env}_delayed_jobs.log"
      run "chmod 664 #{shared_path}/log/#{rails_env}.log #{shared_path}/log/#{rails_env}_delayed_jobs.log"
      run "chown -R #{user}:#{hspace_group} #{shared_path}/log #{shared_path}/pids"
    end
  end
end

def ask_for_yes_no_input(question)
  set(:deploy_proceed) { Capistrano::CLI.ui.ask "#{question} (Y/N) > " }
  unless deploy_proceed =~ /^(y|yes)$/i
    puts "quiting ..."
    exit
  end
end
