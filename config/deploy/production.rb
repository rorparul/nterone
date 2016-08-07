set :branch, 'master'

server '184.7.26.58', user: fetch(:user), roles: %w{app db web}
server '184.7.26.56', user: fetch(:user), roles: %w{app db web}
