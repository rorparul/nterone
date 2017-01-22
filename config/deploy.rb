lock '3.5.0'

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

namespace :deploy do
  namespace :db do
    desc "Load the database schema if needed"
    task load: [:set_rails_env] do
      on primary :db do
        if not test(%Q[[ -e "#{shared_path.join(".schema_loaded")}" ]])
          within release_path do
            with rails_env: fetch(:rails_env) do
              execute :rake, "db:schema:load"
              execute :touch, shared_path.join(".schema_loaded")
            end
          end
        end
      end
    end
  end

  before "deploy:migrate", "deploy:db:load"
end

namespace :rails do
  desc 'Open a rails console `cap [staging] rails:console [server_index default: 0]`'
  task :console do
    on roles(:app) do |server|
      server_index = ARGV[2].to_i
      return if server != roles(:app)[server_index]
      puts "Opening a console on: #{host}...."
      cmd = "ssh #{server.user}@#{host} -t 'cd #{fetch(:deploy_to)}/current && ~/.rvm/bin/rvm #{fetch(:rvm_ruby_version)} do bundle exec rails console #{fetch(:rails_env)}'"
      puts cmd
      exec cmd
    end
  end
end
