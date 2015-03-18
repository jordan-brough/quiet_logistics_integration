require 'bundler'

Bundler.require(:default)
require "./quiet_logistics_endpoint"

rollbar_token = ENV['ROLLBAR_ACCESS_TOKEN']
if rollbar_token.blank? && [:staging, :production].include?(QuietLogisticsEndpoint.environment)
  raise("Rollbar access token is not set")
end

if rollbar_token.present?
  Rollbar.configure do |config|
    config.access_token = rollbar_token
    config.environment = QuietLogisticsEndpoint.environment.to_s
  end
end

run QuietLogisticsEndpoint
