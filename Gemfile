source 'https://rubygems.org'
ruby "2.2.1"

gem 'rails', '4.2.0'

# Use Postgresql as the database for Active Record
gem 'pg'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0.3'

# User twitter-bootstrap framework
gem 'bootstrap-sass', '~> 3.3.4'
gem 'sprockets-rails', '~> 2.3.1'
gem 'bootstrap-select-rails'
gem 'bootstrap-wysihtml5-rails'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# templating engine for HTML
gem 'slim', '~> 3.0.3'
gem 'simple_form'

# Use jquery as the JavaScript library
gem 'jquery-rails', '~> 4.0.3'
gem 'jquery-ui-rails', '~> 5.0.5'
gem 'autonumeric-rails'
gem 'parsley-rails'
gem 'jquery-minicolors-rails'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

# Use authentication
gem 'devise', '~> 3.5.1'
gem 'devise_invitable'

# Use for using enumerable fields in model
gem 'enumerize', '~> 0.11.0'

# Use for authentication users
gem 'pundit', '~> 1.0.1'

# User gems for Uploading and resizing files
gem 'carrierwave', '~> 0.10.0'
gem 'mini_magick'
gem 'fog'

gem 'country_select'
gem 'cocoon'
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'
gem 'public_activity'
gem 'kaminari'
gem 'csv-importer'

group :doc do
  gem 'sdoc', require: false
end

group :development do
  gem 'better_errors',     '~> 2.1.1'
  gem 'binding_of_caller', '~> 0.7.2'
  gem 'meta_request',      '~> 0.3.4'
  gem 'pry-rails',         '~> 0.3.4'
  gem 'pry-byebug',        '~> 3.1.0'
  gem 'annotate'
  gem 'rails-erd'
  gem 'traceroute'
  gem "letter_opener"
end

group :test do
  gem 'rspec-rails',        '~> 3.3.1'
  gem 'factory_girl_rails', '~> 4.5.0'
  gem 'faker',              '~> 1.4.3'
  gem 'database_cleaner',   '~> 1.4.1'
end

group :development, :test do
  gem 'dotenv-rails'

  gem 'capistrano'
  gem 'capistrano-rvm'
  gem 'capistrano-rails'
  gem 'capistrano-passenger'
end

group :production do
  # gem 'rails_12factor'
  # gem 'wkhtmltopdf-heroku'
end
