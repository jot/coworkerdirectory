class SetUpNewTeam
  @queue = :team

  def self.perform(team_uid)
    t = Team.find_by_uid(team_uid)
    puts "Setting up #{t.name}..."
    t.check_presence
    t.load_users
    t.load_channels
    t.load_questions
    t.admin.create_welcome_messages
    t.notify_inuda("#{self.domain}.cabinbot.com created by #{self.admin_name} (#{self.admin_email})")
    puts "Set up #{t.name}."
  end
end