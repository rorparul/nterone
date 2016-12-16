namespace :deploy do
  desc "sitemap refresh"
  task :sitemap_refresh do
    on primary :web do |host|
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'sitemap:refresh'
        end
      end
    end
  end

  after 'deploy:published', 'deploy:sitemap_refresh'
end
