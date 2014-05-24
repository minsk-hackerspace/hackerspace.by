
require 'rvm/capistrano'
require 'bundler/capistrano'
require 'capistrano/ext/multistage'
require 'rubygems'
require 'action_view'

set :default_stage, 'staging'

set :application, 'hspace'

set :user, 'deployer'  # The server's user for deploys

set :hspace_user, 'hspace'
set :hspace_group, 'hspace'

set :rvm_ruby_string, '2.1.1'
set :rvm_type, :system
set :bundle_dir, ''
set :bundle_flags, '--system --quiet'

default_run_options[:pty] = true  # Must be set for the password prompt from git to work
ssh_options[:forward_agent] = true
set :use_sudo, true
# ssh_options[:verbose] = :debug

#set :rvm_ruby_string, '1.9.2-p290'
#set :rvm_type, :system

set :repository, 'git@github.com:k2m30/hspace.git'
set :scm, 'git'
#set :scm_passphrase, 'PUTPASSWORDHERE'
set :scm_verbose, true
set :deploy_via, :remote_cache
set :deploy_to, '/var/www/hspace'
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

task :stop_thin do
  run 'sudo service thin stop' unless initial_deployment
end

task :start_thin do
  begin
    run 'sudo service thin start'
  rescue Exception => boom
    throw boom unless initial_deployment
  end
end

namespace :rvm do
  task :trust_rvmrc do
    run "rvm rvmrc trust #{release_path}"
  end
end

namespace :deploy do
  %w(start stop restart).each do |action|
    desc "#{action} the Thin processes"

    task action.to_sym do
      find_and_execute_task("thin:#{action}")
    end
  end

  # desc "Restart the application."
  # task :restart, :roles => :app do
  #   run "sudo service thin restart"
  #   #run "ls"
  # end
end

namespace :db do
  task :db_config, :except => { :no_release => true }, :role => :app do
    run "cp -f ~/database.yml #{release_path}/config/database.yml"
  end
end

after 'deploy:finalize_update', 'db:db_config'

namespace :thin do
  %w(start stop restart).each do |action|
    desc "#{action} the app's Thin Cluster"
    task action.to_sym, :roles => :web do
      run "cd #{release_path} && bundle exec thin #{action} -d"
    end
  end
end

task :do_post_update_code_work do
  # install gems as needed in shared bundle folder instead of gemset
  run "rm -f #{release_path}/.rvmrc"
  run "cd #{release_path} && bundle install --without development test"

  # switch cache folder to be owned by low priv process that will be running under thin
  run "mkdir -p #{release_path}/tmp/cache"

  if initial_deployment
    #Note that mongo must be set up and configured before the initial deployment,
    #or this will not work.
    run "cd #{release_path} && #{rake} db:setup", :only => { :primary => true }
  else
    run "cd #{release_path} && #{rake} db:migrate", :only => { :primary => true }
  end

  #run "cd #{release_path} && #{rake} yard"

end

#after 'deploy', 'rvm:trust_rvmrc'
before 'deploy:setup', 'rvm:install_rvm'
before 'deploy:setup', 'rvm:install_ruby'
after 'deploy:update_code', :do_post_update_code_work

# ---------------------
# fancy deploy features
# ---------------------
class DeployHelper
  include ActionView::Helpers::DateHelper
end

before 'deploy', 'deploy:check_for_initial_deployment'
before 'deploy', 'deploy:check_branch'
after 'deploy:finalize_update', 'deploy:put_branch'

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
      run "sudo rm -rf #{deploy_to}/*"

      #Set up the directories, ensuring correct ownership. Also create
      #an initial REVISION file with an old, but valid, github tag.
      run "sudo mkdir -p #{deploy_to}/releases/000"
      run "sudo chown -R #{user}:#{user} #{deploy_to}"
      run "sudo ln -s #{deploy_to}/releases/000 #{deploy_to}/current"
      run "sudo echo 5e22b77e7f07d585ebe9a58eea927e3b280d0e11 > #{deploy_to}/current/REVISION"

      #Create and set proper ownership/permissions on these as well. Be sure to do
      #this AFTER the above.
      run "sudo mkdir -p #{shared_path}"
      run "sudo chown #{user}:#{user} #{shared_path}"
      run "sudo mkdir -p -m 2775 #{shared_path}/log"
      run "sudo mkdir -p -m 2775 #{shared_path}/pids"
      run "sudo touch #{shared_path}/log/#{rails_env}.log"
      run "sudo touch #{shared_path}/log/#{rails_env}_delayed_jobs.log"
      run "sudo chmod 664 #{shared_path}/log/#{rails_env}.log #{shared_path}/log/#{rails_env}_delayed_jobs.log"
      run "sudo chown -R #{hspace_user}:#{user} #{shared_path}/log #{shared_path}/pids"
    end
  end

  task :check_branch do
    # check which remotes exist?
    if ['staging', 'production'].include?(branch)
      if `git show-ref upstream/#{branch}; true` != ''
        set :branch_reference, "upstream/#{branch}"
      elsif `git show-ref origin/#{branch}; true` != ''
        set :branch_reference, "origin/#{branch}"
      elsif `git show-ref heads/#{branch}; true` != ''
        set :branch_reference, "heads/#{branch}"
      else
        puts "Git could not find branch #{branch}"
        exit
      end
    else
      if `git show-ref upstream/master; true` != ''
        set :branch_reference, 'upstream/master'
      elsif `git show-ref origin/master; true` != ''
        set :branch_reference, 'origin/master'
      elsif `git show-ref heads/master; true` != ''
        set :branch_reference, 'heads/master'
      else
        puts 'Git could not find branch master'
        exit
      end
    end
    puts "Branch reference: #{branch_reference}"


    deployed_version = current_revision
    new_version = real_revision
    if remote_file_exists?("#{current_path}/BRANCH")
      # fetch current branch info
      deployed_branch_info = capture("cat #{current_path}/BRANCH; true")
      deployed_branch, deployed_by, deployed_time = deployed_branch_info.lines.first.split(';')

      # check if the fork point can be used as the diff base
      info_lines = deployed_branch_info.lines.to_a.map{|l| l.strip}
      if (info_lines.size >= 4 && info_lines[1] == '--branch_fork' && info_lines[3] == '--branch_fork')
        s = info_lines[2].split('|')
        if s.size >= 5
          set :hspace_user, 'hspace'
          set :fork_info, [s[1], s[2], s[3], s[4]]
        end
      end

      # check diffs
      diff = ''
      if ['master', 'staging', 'production'].include?(branch)
        # deploy over unmerged local branch
        if fork_info && fork_info[0]
          if (diff = `git log #{fork_info[0]}..#{branch_reference} --oneline`) != ''
            diff = format_diffs(diff)
            diff = text_underline('New commits since last deploy') + diff
          else
            diff << "No new commits since last deploy!\nDeploying: #{new_version}"
          end
        else
          exist_on_branch = run_locally %Q{git branch -a --contains #{deployed_version}; true}
          if exist_on_branch =~ /^. (remotes\/)?#{branch_reference} *$/m
            if (diff = `git log #{deployed_version}..#{branch_reference} --oneline`) != ''
              diff = format_diffs(diff)
              diff = text_underline('New commits since last deploy') + diff
            else
              diff = "No new commits since last deploy!\nDeploying: #{new_version}"
            end
          else
            diff = "WARNING: #{deployed_version} doesn't exist on your #{branch} branch!\n"
            diff << "Deploying: #{new_version}"
          end
        end
      else # local branch
        if (diff = `git log $(git merge-base #{branch_reference} #{branch})..#{branch} --oneline`) != ''
          diff = format_diffs(diff)
          diff = text_underline("Commits to be pushed from branch #{branch}") + diff

          diff = "Branch to be deployed: #{branch}\n" << "="*80 << "\n" << diff
        else
          diff = "Branch #{branch} may have been merged already!\nDeploying: #{branch} @ #{new_version}"
        end
      end

      puts text_divider
      puts text_underline("Version Currently on Server")
      if ['master', 'staging', 'production'].include?(deployed_branch)
        puts "    Branch: \033[42m\033[1;37m#{deployed_branch}\033[0m" if deployed_branch
      else
        puts "    Branch: \033[41m\033[1;37m#{deployed_branch}\033[0m" if deployed_branch
      end
      puts "    Commit: #{deployed_version}" if deployed_version
      puts "      Time: #{parse_time(deployed_time)} (#{deployed_time})" if deployed_time
      puts "        By: #{deployed_by}" if deployed_by
      if fork_info
        puts ""
        puts text_underline("Branch #{deployed_branch} is based on master at")
        puts "    Commit: \033[37m#{fork_info[0]}\033[0m" if fork_info[0]
        puts "      Time: #{parse_time(fork_info[2])} (#{fork_info[2]})" if fork_info[2]
        puts "        By: #{fork_info[1]}" if fork_info[1]
      end
      puts text_divider
      puts diff
      puts text_divider

      if deployed_by != ENV['USER'] && deployed_branch != branch
        puts "WARNING: #{deployed_by} has branch #{deployed_branch} deployed"
        ask_for_yes_no_input "Are you sure you want to proceed?"
      else
        ask_for_yes_no_input "Continue?"
      end
    end
  end

  task :put_branch do
    branch_info = "#{branch};#{ENV['USER']};#{Time.now.utc}"
    if ['master', 'staging', 'production'].include?(branch)
      branch_head = run_locally %Q{git log --pretty=format:"|%H|%ae|%ai|%s" -n 1 #{branch_reference}; true}
      branch_info += "\n--branch_head\n#{branch_head}\n--branch_head" if branch_head =~ /^|/

      if fork_info
        branch_info += "\n--prior_revision_base\n|#{fork_info[0]}|\n--prior_revision_base"

        pushed_revisions = run_locally %Q{git log --pretty=format:"|%H|%ae|%ai|%s" #{fork_info[0]}..#{real_revision}; true}
        branch_info += "\n--pushed_revisions\n#{pushed_revisions}\n--pushed_revisions" if pushed_revisions =~ /^|/
      else
        branch_info += "\n--prior_revision_base\n|#{current_revision}|\n--prior_revision_base"

        pushed_revisions = run_locally %Q{git log --pretty=format:"|%H|%ae|%ai|%s" #{current_revision}..#{real_revision}; true}
        branch_info += "\n--pushed_revisions\n#{pushed_revisions}\n--pushed_revisions" if pushed_revisions =~ /^|/
      end
    else # local branch
      branch_fork = run_locally %Q{git log --pretty=format:"|%H|%ae|%ai|%s" --no-walk $(git merge-base #{branch_reference} #{branch}); true}
      branch_info += "\n--branch_fork\n#{branch_fork}\n--branch_fork" if branch_fork =~ /^|/

      branch_unmerged = run_locally %Q{git log --reverse --pretty=format:"|%H|%ae|%ai|%s" --no-walk $(git cherry #{branch_reference} #{branch}| grep "^+"| cut -d" " -f2) | sort -t"|" -rk3; true}
      branch_info += "\n--branch_unmerged\n#{branch_unmerged}\n--branch_unmerged" if branch_unmerged =~ /^|/
    end

    put branch_info, "#{release_path}/BRANCH"
  end
end

def ask_for_yes_no_input(question)
  set(:deploy_proceed) { Capistrano::CLI.ui.ask "#{question} (Y/N) > " }
  unless deploy_proceed =~ /^(y|yes)$/i
    puts "quiting ..."
    exit
  end
end

def remote_file_exists?(full_path)
  'true' ==  capture("if [ -e #{full_path} ]; then echo 'true'; fi").strip
end

def text_divider
  "="*80
end

def text_underline(line)
  line && line.size > 1 ? line << ":\n" << "-"*(line.size-2) << "\n" : ''
end

def format_diffs(diffs)
  diffs.gsub!(/^([a-f0-9]+) /, "\033[1;32m\\1\033[0m - ")
  diffs = "    " << diffs.gsub("\n", "\n    ") << "\n"
  diffs = diffs.lines.map{|l|l.scan(/.{1,100}/).join("\n"<<" "*14).gsub(/([^ ]*)\n {14}/m,"\n"<<" "*14<<"\\1")}.join("\n")
end

def parse_time(time_string)
  if time_string
    helper = DeployHelper.new

    time_string.strip!
    restore_value = I18n.enforce_available_locales
    I18n.enforce_available_locales = false
    time_in_words = helper.time_ago_in_words(
        Time.parse(time_string)
    ).concat(" ago")
    I18n.enforce_available_locales = restore_value
    return time_in_words
  else
    return nil
  end
end