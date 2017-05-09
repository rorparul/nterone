every 1.day, :at => '1:00 am' do
  rake '-s sitemap:production_refresh'
end

every 1.day, :at => '1:00 am' do
  rake 'backup:db'
end

# every 1.day, :at => '2:00 am' do
#   rake 'staging:db_clone'
# end
