desc "This task is called by the Heroku scheduler add-on"

task :check_presence => :environment do
  puts "Checking presence..."
  Team.check_presences
  puts "done."
end