require 'capistrano/setup'
require 'capistrano/deploy'
require "capistrano/scm/git"
require 'capistrano/rvm'
require 'capistrano/rails'
require 'capistrano/passenger'
require 'capistrano/sidekiq'
require 'capistrano/sidekiq/monit'
require 'capistrano/ssh_doctor'
require 'capistrano/sitemap_generator'
require 'whenever/capistrano'

install_plugin Capistrano::SCM::Git

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
