class ProcessJoinJob
  @queue = :join

  def self.perform(user_id)
    puts "Processing user #{user_id}..."
    user = User.find(user_id)

    gifs = YAML::load_file("#{Rails.root}/data/welcome_gifs.yml")
    
    user.team.post_to_general "Welcome aboard <@#{user.uid}>!", gifs.sample

    #team.send_im data['user']['id'], "Hey <@#{data['user']['id']}> it really is awesome to have you aboard! Give me a shout if I can help you with anything."

    # user = User.where(team: client.owner, user_id: data.user.id).first
    # logger.info "JOIN CLIENT: #{client.inspect}"
    Resque.enqueue(UpdateTeamData, user.team.uid)

  end
end