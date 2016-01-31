module SlackCabinbot
  module Commands
    class Ping < SlackRubyBot::Commands::Base
      command 'ping' do |client, data, _match|
        client.message text: "pong: #{data}", channel: data.channel
      end
    end
  end
end