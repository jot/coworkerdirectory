desc "This task is called to run the Slack bot"

task :run_bot => :environment do

  $LOAD_PATH.unshift(File.dirname(__FILE__))

  require 'slack_cabinbot'

  logger = Rails.logger

  # Thread.new do
    begin
      EM.run do
        SlackCabinbot::Service.start_from_database!
      end
    rescue StandardError => e
      puts e
      raise e
    end
  # end
end
