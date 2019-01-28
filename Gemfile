source 'https://rubygems.org'

gem 'aws-sdk', '~> 3'
gem 'bootsnap', require: false
gem 'coffee-rails', '~> 4.2'
gem 'enumerize'
gem 'jbuilder', '~> 2.5'
gem 'power-types'
gem 'puma', '~> 3.11'
gem 'rack-cors', '~> 0.4.0'
gem 'rails', '~> 5.2.2'
gem 'rails-i18n'
gem 'sass-rails', '~> 5.0'
gem 'spring'
gem 'sqlite3'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'
gem 'webpacker', github: 'rails/webpacker'

group :production do
  gem 'heroku-stage'
  gem 'rack-timeout'
  gem 'rails_stdout_logging'
end

group :test do
  gem 'rspec_junit_formatter', '0.2.2'
  gem 'shoulda-matchers', require: false
end

group :development do
  gem 'annotate'
end

group :development, :test do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'guard-rspec', require: false
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rspec-nc', require: false
  gem 'rspec-rails'
end

group :production, :development, :test do
  gem 'tzinfo-data'
end
