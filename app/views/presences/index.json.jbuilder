json.array!(@presences) do |presence|
  json.extract! presence, :id, :team_id, :team_uid, :active_ids, :active_uids, :away_ids, :away_uids, :slack_api_data, :checked_at
  json.url presence_url(presence, format: :json)
end
