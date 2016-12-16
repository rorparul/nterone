namespace :sitemap do
  desc "sitemap refresh only on production"
  task :production_refresh do
    hostname = `hostname`.strip
    unless hostname.include? "staging"
      execute :rake, "sitemap:refresh"
    end
  end
end
