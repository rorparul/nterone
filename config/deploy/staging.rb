set :branch, 'staging'

server '184.7.18.90', user: fetch(:user), roles: %w(app db web)
