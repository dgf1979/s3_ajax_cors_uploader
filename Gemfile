source 'http://rubygems.org'
ruby '1.9.3'

gem 'rails', '3.2.8'

# Core
gem 'pg'
gem 'thin'
gem 'rails_admin'
gem 'jquery-rails'
gem 'newrelic_rpm'

# Uploads and images
gem 'fog'
gem 'carrierwave'
gem 'mini_magick'

# AWS SDK (for Amazon S3 helpers)
gem 'aws-sdk', '~> 2'

group :assets do
  gem 'sass-rails', "~> 3.2.3"
  gem 'coffee-rails', "~> 3.2.1"
  gem 'uglifier', '>= 1.0.3'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'rack-test'
  gem 'capybara'
  gem 'launchy'
  gem 'pry-rails'
  gem 'with_model'
  gem 'database_cleaner'
end

group :production do
  gem 'rails_12factor'
end
