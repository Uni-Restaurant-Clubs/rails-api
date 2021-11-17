Sidekiq.configure_server do |config|
  config.redis = { network_timeout: 5 }
end
