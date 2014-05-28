set :rails_env, 'production'

server 'hackerspace.by', :app, :web, :db, :primary => true
set :deploy_to, '/srv/www/dev.hackerspace.by'

set :branch, 'master' unless exists?(:branch)

set :keep_releases, 5
after 'deploy:restart', 'deploy:cleanup'