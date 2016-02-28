module SlackCabinbot
  module Hooks
    module TeamJoin
      extend SlackRubyBot::Hooks::Base

      def team_join(client, data)
        team = Team.find_by_uid(data["user"]["team_id"])
        logger.info "JOIN DATA: #{data['user']['id']} joined #{data["user"]["team_id"]}"


        gifs = YAML::load_file("#{Rails.root}/data/welcome_gifs.yml")
        
        team.post_to_general "Welcome aboard <@#{data['user']['id']}>!", gifs.sample

        #team.send_im data['user']['id'], "Hey <@#{data['user']['id']}> it really is awesome to have you aboard! Give me a shout if I can help you with anything."

        # user = User.where(team: client.owner, user_id: data.user.id).first
        # logger.info "JOIN CLIENT: #{client.inspect}"
        logger.info "JOIN DATA: #{data['user']['id']} joined #{data["user"]["team_id"]}"
        Resque.enqueue(UpdateTeamData, team.uid)
      end
    end
  end
end