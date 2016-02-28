json.array!(@answers) do |answer|
  json.extract! answer, :id, :user_id, :question_id, :question_message_id, :question_text, :answer_message_id, :answer_text, :url, :properties, :asked_at, :answered_at, :asked_by
  json.url answer_url(answer, format: :json)
end
