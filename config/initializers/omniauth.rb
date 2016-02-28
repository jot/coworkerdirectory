Rails.application.config.middleware.use OmniAuth::Builder do
  provider :slack, Rails.application.secrets.omniauth_provider_key, Rails.application.secrets.omniauth_provider_secret, 
  :scope=>"identify,team:read,users:read,bot,channels:read,reactions:read"
  #admin,client
end