module SlackCabinbot
  module Commands
    class Unknown < SlackRubyBot::Commands::Base
      match(/^(?<bot>\S*)[\s]*(?<expression>.*)$/)

      def self.call(client, data, _match)
        message = Message.create_from_slack_data(data)

        dumb = YAML::load_file("#{Rails.root}/data/dumb.yml")

        positive = YAML::load_file("#{Rails.root}/data/positive.yml")

        # send_message client, data.channel, "Sorry I don't understand. #{dumb.sample}\nI'll ask someone about that and get back to you."

        send_message client, data.channel, "#{positive.sample.humanize}!\nI'll ask someone about that and get back to you."
      end
    end
  end
end