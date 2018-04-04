Make sure the following Sidekiq queues are running:
- default
- mailers

Command:
- bundle exec sidekiq -q default -q mailers
