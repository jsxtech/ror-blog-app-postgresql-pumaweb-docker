require "active_support/core_ext/integer/time"

Rails.application.configure do
  config.enable_reloading = false
  config.eager_load = ENV["CI"].present?
  config.consider_all_requests_local = true

  config.action_controller.perform_caching = false
  config.cache_store = :null_store

  config.action_controller.allow_forgery_protection = false

  config.secret_key_base = "test_only_secret_key_base_do_not_use_in_production"

  config.active_support.deprecation = :stderr
  config.active_support.disallowed_deprecations_mode = :raise
end
