# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'animefolio'
set :repo_url, 'git@github.com:akihokurino/animefolio.git'
set :deploy_to, '/var/www'
set :user, 'root'
set :branch, 'master'
set :scm, :git
set :rails_env, 'production'
set :pty, true
set :default_env, { path: "/root/.rbenv/shims:/root/.rbenv/bin:$PATH" }
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets}
#set :default_env, {
#    global_gem_home: "/usr/local/bin/gem",
#    gem_home: "$HOME/.gem",
#    gem_path: "$GEM_HOME:$GLOBAL_GEM_HOME",
#    path: "$GEM_HOME/bin:$GLOBAL_GEM_HOME/bin:/usr/bin:$PATH",
#}
#set :deploy_via, :rsync_with_remote_cache
#set :rsync_options, '-az --delete --delete-excluded --exclude=.git'
set :bundle_without, %w{development debug test deployment}.join(' ')
#set :bundle_without, [:development, :test]
set :bundle_flags, '--deployment'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
# set :deploy_to, '/var/www/my_app'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  desc 'Restart application'
  task :restart do
    invoke 'unicorn:restart'
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
