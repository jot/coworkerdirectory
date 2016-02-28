class UpdateTeamData
  @queue = :team

  def self.perform(team_uid)
    t = Team.find_by_uid(team_uid)
    puts "Updating data for #{t.name}..."
    t.load_users
    t.load_channels
    puts "Updated data for #{t.name}."
  end
end