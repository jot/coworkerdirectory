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


task :update_all_user_scores => :environment do
  puts "Update all scores..."
  User.get_all_scores
  puts "done."
end