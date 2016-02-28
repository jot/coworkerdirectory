desc "This task is called by the Heroku scheduler add-on"

task :check_presence => :environment do
  puts "Checking presence..."
  Team.check_presences
  puts "done."
end

task :update_all_team_data => :environment do
  puts "Queuing data update for all teams..."
  Team.update_all_data
  puts "done."
end