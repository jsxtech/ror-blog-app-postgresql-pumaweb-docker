require "active_support/core_ext/integer/time"

Rails.application.configure do
  config.enable_reloading = false
  config.eager_load = true
  config.consider_all_requests_local = false

  config.force_ssl = true
  config.assume_ssl = true

  config.secret_key_base = ENV["SECRET_KEY_BASE"]

  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info").to_sym
  config.log_tags = [:request_id]

  config.action_controller.perform_caching = true

  config.active_record.dump_schema_after_migration = false

  config.active_support.report_deprecations = false
end
