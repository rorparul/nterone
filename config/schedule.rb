every 1.day, :at => '1:00 am' do
  rake '-s sitemap:production_refresh'
end

every 1.day, :at => '1:00 am' do
  rake 'backup:db'
end

every 1.hour do
  runner "Cart.notify_that_cart_not_empty"
end

every 1.day, :at => '2:00 am' do
  runner "EventReminderWorker.perform_async"
end

# every 1.day, :at => '2:00 am' do
#   rake 'staging:db_clone'
# end
