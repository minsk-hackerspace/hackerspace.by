set :rails_env, 'production'

server 'hackerspace.by:2220', :app, :web, :db, :primary => true
set :deploy_to, '/srv/www/hackerspace.by'

set :branch, 'master' unless exists?(:branch)
set :user, 'hudbrog'  # The server's user for deploys

set :keep_releases, 5
after 'deploy:restart', 'deploy:cleanup'