set :branch, 'master'

server '184.7.26.58', user: fetch(:user), roles: %w{app db web}
