class Channel < ActiveRecord::Base
  belongs_to :team

  def self.list_for(uid)
    Channel.where('slack_data @> ?', {'members':[uid]}.to_json)
  end

  def team_domain
    team.domain
  end

  def members
    team.coworkers.where(:uid=>slack_data["members"])
  end
end
