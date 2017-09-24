lock '3.9.0'

require 'capistrano-db-tasks'

set :repo_url, 'git@github.com:ryanstorberg/nterone.git'
set :rails_env, "production"
set :application, 'nterone'
set :passenger_restart_with_touch, true
set :user, 'deploy'
set :deploy_to, "/home/#{fetch(:user)}"
set :linked_files, fetch(:linked_files, []).push('config/database.yml')
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/uploads')
set :deploy_via, :remote_cache
set :sidekiq_processes, 2
set :sidekiq_user, fetch(:user)
set :sidekiq_options_per_process, ["--queue default", "--queue mailer"]

# dbtasks
set :db_remote_clean, true
set :db_local_clean, true

set :ssh_options, {
  forward_agent: true,
  auth_methods: %w(publickey)
}

namespace :log do
  desc "Tail all application log files"
  task :tail do
    on roles(:app) do |server|
      execute "tail -f #{current_path}/log/*.log" do |channel, stream, data|
        puts "#{channel[:host]}: #{data}"
        break if stream == :err
      end
    end
  end
end

namespace :deploy do
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      within release_path do
        execute :rake, "sitemap:production_refresh", "RAILS_ENV=#{fetch :rails_env}"
      end
    end
  end

  task :update_repo_url do
    on roles(:all) do
      within repo_path do
        execute :git, 'remote', 'set-url', 'origin', fetch(:repo_url)
      end
    end
  end
end
