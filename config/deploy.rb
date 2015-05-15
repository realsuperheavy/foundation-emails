# use local key for authentication
ssh_options[:forward_agent] = true
default_run_options[:pty] = true

set :application, "ink"
set :repository,  "git@github.com:zurb/#{application}.git"
set :user, application
set :branch, 'marketing'
set :deploy_to, "/var/www/#{application}"
set :use_sudo, false

set :scm, :git

server 'susan.zurb.com', :web

after "deploy:update_code", "deploy:link_cached_files", "deploy:link_downloads", "deploy:link_docs"
set :keep_releases, 3
after "deploy:update", "deploy:cleanup"

namespace :deploy do
  task :default do
    update
  end
  
  desc "Symlink cached files"
  task :link_cached_files do
    run "rm -rf #{release_path}/public/cache"
    run "ln -nfs #{shared_path}/cache #{release_path}/public"
  end

  desc "Symlink downloads"
  task :link_downloads do
    run "ln -fs #{shared_path}/downloads #{release_path}/downloads"
  end

  desc "Symlink docs"
  task :link_docs do
    run "ln -fs #{shared_path}/docs #{release_path}/docs"
  end
end