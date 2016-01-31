json.array!(@teams) do |team|
  json.extract! team, :id, :name, :uid, :domain, :email_domain, :bot_user_id, :bot_access_token, :slack_data
  json.url team_url(team, format: :json)
end
