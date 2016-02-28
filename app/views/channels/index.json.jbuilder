json.array!(@channels) do |channel|
  json.extract! channel, :id, :uid, :name, :created, :creator, :is_archived, :is_member, :num_members, :team_id, :slack_data, :properties
  json.url channel_url(channel, format: :json)
end
