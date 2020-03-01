Rails.application.config.middleware.use OmniAuth::Builder do
    provider :google_oauth2, '781036429987-233hfr2peanens28knfbc2ugctorr6t1.apps.googleusercontent.com', 'zcGqzNHjslAPbYAtrEALQMv4'
  end