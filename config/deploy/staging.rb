set :branch, ENV['BRANCH'] || 'master'

server '18.213.111.187', user: fetch(:user), roles: %w(app db web)
