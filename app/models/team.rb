class Team < ActiveRecord::Base

  def coworkers
    User.where(team_slack_id: self.uid)
  end

end
