# -*- encoding : utf-8 -*-
# config valid only for Capistrano 3.1
lock '3.1.0'

set :application, 'bazomania'
set :repo_url, "git@github.com:grandison/bm.git"

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default deploy_to directory is /var/www/my_app
# set :deploy_to, '/var/www/my_app'

# Default value for :scm is :git
set :scm, :git
set :deploy_via, :remote_cache
set :user, :bazomania
set :deploy_to, "/var/www/rails/#{fetch(:application)}"

set :unicorn_binary, "bundle exec unicorn"
set :shared_path, "#{fetch(:deploy_to)}/shared"
set :unicorn_config, "#{fetch(:shared_path)}/config/unicorn.rb"
set :unicorn_pid, "#{fetch(:shared_path)}/pids/unicorn.pid"

set :delayed_job_args, "-n 2"

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
set :keep_releases, 5

 set :ssh_options, {
   # keys: %w(/home/rlisowski/.ssh/id_rsa),
   forward_agent: true,
   user: fetch(:user)
   # auth_methods: %w(password)
 }

set :linked_files, %w{config/database.yml}
set :unicorn_config, "#{shared_path}/config/unicorn.rb"

SSHKit.config.command_map[:rake]  = "bundle exec rake"
SSHKit.config.command_map[:rails] = "bundle exec rails"

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # deploy.web.disable
      # stop
      # start
      # deploy.web.enable
    end
  end

  task :start_unicorn do
    on roles(:app), in: :sequence, wait: 5 do |host|
      execute "cd #{release_path} && RAILS_ENV=#{fetch(:stage)} /usr/local/rvm/bin/rvm default do bundle exec unicorn -c #{fetch(:unicorn_config)} -E #{fetch(:stage)} -D"
    end
  end

  task :stop_unicorn do
    on roles(:app), in: :sequence, wait: 10 do |host|
      execute "test -e #{fetch(:unicorn_pid)} && kill `cat #{fetch(:unicorn_pid)}`; true"
    end
  end

  task :restart_delayed_job do                                                                                                           
    on roles(:app), in: :sequence, wait: 10 do |host|
      execute "cd #{release_path} && (RAILS_ENV=production /usr/local/rvm/bin/rvm default do bin/delayed_job -n 2 restart)"                                              
    end
  end 

  before 'deploy:assets:precompile', :stop_unicorn
  after :publishing, :start_unicorn

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
    end
  end
end
