module SlackCabinbot
  module Commands
    class Unknown < SlackRubyBot::Commands::Base
      match(/^(?<bot>\S*)[\s]*(?<expression>.*)$/)

      def self.call(client, data, _match)
        begin

          client.typing(channel: data.channel)
#          sleep(3)
          # message = Message.create_from_slack_data(data)

          # if message.answer.nil?
          #   if data.channel[0] == "D"
          #     if message.is_positive?
          #       message.user.positive_response
          #     elsif message.is_negative?
          #       message.user.negative_response
          #     else
          #       dumb = YAML::load_file("#{Rails.root}/data/dumb.yml")
          #       send_message client, data.channel, "Sorry I don't understand. #{dumb.sample}\nI'll ask someone about that and get back to you."
          #     end
          #   else
          #     dumb = YAML::load_file("#{Rails.root}/data/dumb.yml")
          #     send_message client, data.channel, "Sorry I don't understand. #{dumb.sample}\nI'll ask someone about that and get back to you."
          #   end
          # end

        rescue Exception=>e
          send_message client, data.channel, "Sorry I’m feeling a little under the weather. Forgive me for I am still finding my sea legs. I don’t mean to be rude but it’s probably best you don’t talk to me for a while."
        end

        #positive = YAML::load_file("#{Rails.root}/data/positive.yml")
        #send_message client, data.channel, "#{positive.sample.humanize}!\nI'll ask someone about that and get back to you."
      end
    end
  end
end