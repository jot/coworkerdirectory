json.array!(@messages) do |message|
  json.extract! message, :id, :channel_uid, :channel_id, :team_uid, :team_id, :text, :ts, :timestamp, :message_type, :message_subtype, :user_uid, :user_id, :properties, :slack_data
  json.url message_url(message, format: :json)
end
