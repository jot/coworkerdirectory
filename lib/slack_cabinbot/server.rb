module SlackCabinbot
  class Server < SlackRubyBot::Server
    include SlackCabinbot::Hooks::TeamJoin
    # include SlackCabinbot::Hooks::UserChange
    
    attr_accessor :team

    def initialize(attrs = {})
      @team = attrs[:team]
      fail 'Missing token' unless @team
      options = { token: @team.token }
      super(options)
      client.owner = @team
    end

    def restart!(wait = 1)
      # when an integration is disabled, a live socket is closed, which causes the default behavior of the client to restart
      # it would keep retrying without checking for account_inactive or such, we want to restart via service which will disable an inactive team
      EM.next_tick do
        logger.info "#{team.name}: socket closed, restarting ..."
        SlackCabinbot::Service.restart! team, self, wait
        client.owner = team
      end
    end

  end
end