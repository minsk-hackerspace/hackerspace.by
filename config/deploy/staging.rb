if ENV['LOCAL_REPOS'] && ENV['LOCAL_REPOS'] =~ /^true$/i
  local_repos_dir = File.expand_path("../../.git", File.dirname(__FILE__))
  if File.directory?(local_repos_dir)
    set :repository,  "#{local_repos_dir}"
    set :local_repository, "#{local_repos_dir}"
    set :deploy_via, :copy
  else
    puts 'No local repository found!  quiting...'
    exit
  end
end

set :rails_env, 'staging'

set :deploy_to, '/srv/www/dev.hackerspace.by'

server 'hs.gcode.ws', :app, :web, :db, :primary => true

set :branch, 'master' unless exists?(:branch)

set :keep_releases, 5
after 'deploy:restart', 'deploy:cleanup'