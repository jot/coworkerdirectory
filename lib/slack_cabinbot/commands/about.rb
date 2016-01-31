module SlackCabinbot
  module Commands
    class Default < SlackRubyBot::Commands::Base
      command 'about'
#      match(/^(?<bot>[\w[:punct:]@<>]*)$/)

      def self.call(client, data, _match)
        send_message client, data.channel, "Ahoy there! I’m Cabinbot.\n @jot has given me the duty of helping you out at The Skiff.\n We want you to find the perfect balance of comfort and productivity."
        send_message client, data.channel, "I also run http://theskiff.coworker.directory (let me know if you want to add something to your profile)."
        send_message client, data.channel, "...and send the ocassional tweet via http://twitter.com/theskiff (let me know if you want to promote something."
        send_message client, data.channel, "I take this job pretty seriously so I’ll be checking in with you from time to time.\n How are things going for you so far?"
      end
    end
  end
end