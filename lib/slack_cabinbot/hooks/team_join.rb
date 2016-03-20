module SlackCabinbot
  module Hooks
    module TeamJoin
      extend SlackRubyBot::Hooks::Base

      def team_join(client, data)
        begin
          puts "Team join detected #{data['user']['id']}"
          puts data.inspect

          client.typing(channel: client.owner.general_channel.uid)

          user = client.owner.create_user_from_slack_id(data['user']['id'])
          Resque.enqueue(ProcessJoinJob, user.id)
          puts "ProcessJoinJob Queued for #{data['user']['id']}"
        
        rescue Exception=>e
          puts "FAILED: To queue ProcessJoinJob for #{data['user']['id']}"
        end
      end
    end
  end
end