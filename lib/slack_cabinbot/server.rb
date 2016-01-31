module SlackCabinbot
  class Server < SlackRubyBot::Server
    # include SlackPongbot::Hooks::UserChange

    attr_accessor :token

    def initialize(attrs = {})
      @token = attrs[:token]
      fail 'Missing token' unless @token
      super(token: @token)
      client.token = @token
    end
  end
end