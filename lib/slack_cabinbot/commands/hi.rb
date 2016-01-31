module SlackCabinbot
  module Commands
    class Hi < SlackRubyBot::Commands::Base
      def self.call(client, data, _match)
        send_message client, data.channel, "Hi <@#{data.user}>! How are things at The Skiff?"
      end
    end
  end
end