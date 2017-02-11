require 'capistrano/setup'
require 'capistrano/deploy'
require 'capistrano/rvm'

# require 'capistrano/rails'
require 'capistrano/bundler' # Rails needs Bundler, right?
require 'capistrano/rails/assets'
# require 'capistrano/rails/migrations'

require 'capistrano/passenger'
require 'capistrano/sidekiq'
require 'capistrano/sidekiq/monit'
require 'capistrano/ssh_doctor'
require 'capistrano/sitemap_generator'
require 'whenever/capistrano'

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
