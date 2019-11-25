source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.6.4"

gem "bootsnap", ">= 1.1.0", require: false
gem "bootstrap", "~> 4.3.1"
gem "bugsnag"
gem "devise"
gem "devise_invitable"
gem "flipper"
gem "flipper-active_record"
gem "flipper-ui"
gem "font-awesome-rails"
gem "jbuilder", "~> 2.5"
gem "jquery-rails", "~> 4.3", ">= 4.3.1"
gem "pg"
gem "prawn-rails"
gem "puma", "~> 3.11"
gem "pundit", "~> 2.0.0"
gem "rails", "~> 5.2.1"
gem "sass-rails", "~> 5.0"
gem "uglifier", ">= 1.3.0"
gem "wicked_pdf", "~> 1.1"
gem "wkhtmltopdf-binary"

group :development, :test do
  gem "better_errors"
  gem "binding_of_caller"
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "capybara-screenshot"
  gem "dotenv-rails"
  gem "factory_bot_rails"
  gem "faker"
  gem "guard-rspec"
  gem "pry"
  gem "pry-rails"
  gem "pry-remote"
  gem "rails-controller-testing"
  gem "rspec-rails", "~> 3.5"
  gem "rubocop"
  gem "rubocop-rspec"
  gem "simplecov", require: false
end

group :development do
  gem "annotate"
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
  gem "capybara", ">= 2.15"
  gem "chromedriver-helper"
  gem "email_spec"
  gem "selenium-webdriver"
  gem "shoulda-matchers"
  gem "webmock"
end

gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
