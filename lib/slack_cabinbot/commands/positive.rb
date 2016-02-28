module SlackCabinbot
  module Commands
    class Positive < SlackRubyBot::Commands::Base
      #'right on', 'by all means', 'okey-dokey', 'aye aye', 'uh-huh', 'very well', '10-4'
      command 'y', 'yes', 'yea', 'yeah', 'yep', 'OK', 'ok',  'affirmative', 'aye', 'roger', 'yup', 'yuppers', 'ja', 'surely', 'amen', 'totally', 'yessir' do |client, data, _match|
        user = User.find_by_uid(data.user)
        user.positive_response
      end
    end
  end
end