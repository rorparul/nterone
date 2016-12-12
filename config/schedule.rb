every 1.day, :at => '1:00 am' do
  rake '-s sitemap:refresh'
end

every 1.hour do
  rake 'sync:public_featured_events'
end

if Setting.stage == 'production'
  every 1.day, :at => '1:00 am' do
    rake 'backup:db'
  end
end

if Setting.stage == 'staging'
  every 1.day, :at => '2:00 am' do
    rake 'staging:db_clone'
  end
end
