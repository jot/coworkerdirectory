json.array!(@questions) do |question|
  json.extract! question, :id, :team_id, :text, :response, :priority, :author_id
  json.url question_url(question, format: :json)
end
