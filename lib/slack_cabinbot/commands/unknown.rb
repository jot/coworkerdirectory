module SlackCabinbot
  module Commands
    class Unknown < SlackRubyBot::Commands::Base
      match(/^(?<bot>\S*)[\s]*(?<expression>.*)$/)

      def self.call(client, data, _match)
        begin
          puts "Message detected."

          client.typing(channel: data.channel)

          message = client.owner.create_message_from_slack_data(data)
          Resque.enqueue(ProcessMessageJob, message.id)
          puts "ProcessMessageJob Queued for #{message.id}"
        rescue Exception=>e
          puts "FAILED: To queue ProcessMessageJob for #{data.inspect}"
          client.say channel: data.channel, text: "Sorry I’m feeling a little under the weather. Forgive me for I am still finding my sea legs. I don’t mean to be rude but it’s probably best you don’t talk to me for a while."
        end

      end
    end
  end
end