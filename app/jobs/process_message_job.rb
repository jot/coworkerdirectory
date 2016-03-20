class ProcessMessageJob
  @queue = :message

  def self.perform(message_id)
    puts "Processing message #{message_id}..."
    message = Message.find(message_id)

    if message.channel_uid[0] == "D"
      message.answer_question
    end

    if message.answer.blank?
      if message.channel_uid[0] == "D"
        if message.is_positive?
          message.user.positive_response
        elsif message.is_negative?
          message.user.negative_response
        else
          dumb = YAML::load_file("#{Rails.root}/data/dumb.yml")
          message.reply "Sorry I don't understand. #{dumb.sample}\nI'll ask someone about that and get back to you."
        end
      else
        dumb = YAML::load_file("#{Rails.root}/data/dumb.yml")
        message.reply "Sorry I don't understand. #{dumb.sample}\nI'll ask someone about that and get back to you."
      end
    end

  end
end