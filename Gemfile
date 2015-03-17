source "https://rubygems.org"

gem 'honeybadger'
gem 'nokogiri'
gem 'aws-sdk'
gem 'timecop'
gem 'multi_json', '~> 1.0'
gem 'sinatra'
gem 'tilt', '~> 1.4.1'
gem 'tilt-jbuilder', require: 'sinatra/jbuilder'
gem 'endpoint_base', github: 'spree/endpoint_base'

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
