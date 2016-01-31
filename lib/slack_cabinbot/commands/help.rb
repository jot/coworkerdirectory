module SlackCabinbot
  module Commands
    class Help < SlackRubyBot::Commands::Base
      def self.call(client, data, _match)
        send_message client, data.channel, 'What would you like me to help you with?'
      end
    end
  end
end