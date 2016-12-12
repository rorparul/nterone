# every 1.day, :at => '5:00 am' do
#   rake "-s sitemap:refresh"
# end

every 1.hour do
  rake 'sync:public_featured_events'
end
