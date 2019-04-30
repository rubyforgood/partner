source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.6.2"

gem "coffee-rails", "~> 4.2"
gem "devise"
gem "devise_invitable"
gem "font-awesome-rails"
gem "jbuilder", "~> 2.5"
gem "pg"
gem "puma", "~> 3.11"
gem "pundit", "~> 2.0.0"
gem "rails", "~> 5.2.1"
gem "sass-rails", "~> 5.0"
gem "turbolinks", "~> 5"
gem "uglifier", ">= 1.3.0"
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.1.0", require: false
gem "bootstrap", "~> 4.1.3"
gem "jquery-rails", "~> 4.3", ">= 4.3.1"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "better_errors"
  gem "binding_of_caller"
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "dotenv-rails"
  gem "factory_bot_rails"
  gem "faker"
  gem "guard-rspec"
  gem "pry"
  gem "pry-rails"
  gem "rspec-rails", "~> 3.5"
  gem "rubocop"
end

group :development do
  gem "annotate"
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem "capistrano-bundler"
  gem "capistrano-rails"
  gem "capistrano-rails-console", require: false
  gem "capistrano-rvm"
  gem "capistrano3-puma"
  gem "letter_opener"
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "web-console", ">= 3.3.0"
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem "capybara", ">= 2.15"
  gem "selenium-webdriver"
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem "chromedriver-helper"
  gem "email_spec"
  gem "shoulda-matchers"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
