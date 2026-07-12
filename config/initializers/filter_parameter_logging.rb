Rails.application.config.filter_parameters += [
  :password, :password_confirmation, :secret_key_base, :token
]
