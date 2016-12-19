namespace :sitemap do
  desc "sitemap refresh only on production"
  task :production_refresh do
    hostname = `hostname`.strip
    unless hostname.include? "staging"
      Rake::Task['sitemap:refresh'].invoke
    end
  end
end
