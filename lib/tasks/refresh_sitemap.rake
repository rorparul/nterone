namespace :sitemap do
  desc "sitemap refresh only on production"
  task :production_refresh do
    unless Setting.current_hostname.include? "staging"
      execute :rake, "sitemap:refresh"
    end
  end
end
