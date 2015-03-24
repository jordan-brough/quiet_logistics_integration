source "https://rubygems.org"
ruby File.read(File.join(File.dirname(__FILE__), '.ruby-version')).strip

gem 'honeybadger'
gem 'nokogiri'
gem 'aws-sdk', '~>1.29'
gem 'timecop'
gem 'multi_json', '~> 1.0'
gem 'sinatra'
gem 'tilt', '~> 1.4.1'
gem 'tilt-jbuilder', require: 'sinatra/jbuilder'
gem 'endpoint_base', github: 'spree/endpoint_base'
gem 'rollbar', '~> 1.4.4'

group :test do
  gem 'rspec'
  gem 'webmock'
  gem 'rack-test'
end

group :production do
  gem 'foreman'
  gem 'unicorn'
end

group :development do
  gem 'pry'
end

group :test, :development do
  gem 'pry-byebug'
end
