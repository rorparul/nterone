lock '3.4.0'

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

set :ssh_options, {
  forward_agent: true,
  auth_methods: %w(publickey)
}

namespace :deploy do
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do

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
