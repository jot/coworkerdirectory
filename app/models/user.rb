class User < ActiveRecord::Base
  enum role: [:user, :vip, :admin]
  after_initialize :set_default_role, :if => :new_record?

  def coworkers
    User.where(team_slack_id: self.team_slack_id)
  end

  def set_default_role
    if User.count == 0
      self.role ||= :admin
    else
      self.role ||= :user
    end
  end

  def full_name
    self.slack_api_data["profile"]["real_name"]
  end

  def image_url
    return slack_api_data["profile"]["image_original"] unless slack_api_data["profile"]["image_original"].blank?
    return slack_api_data["profile"]["image_192"]
  end

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth['provider']
      user.uid = auth['uid']
      user.slack_auth_data = auth
      user.slack_auth_data_updated_at = Time.now
      user.team_slack_id = auth['info']['team_id']
      user.team_name = auth['info']['team']
      user.team_domain = auth['info']['team_domain']
      if auth['info']
         user.name = auth['info']['name'] || ""
      end
    end
  end

  def update_with_omni_auth(auth)
    self.slack_auth_data = auth
    self.slack_auth_data_updated_at = Time.now
    if auth['info']
       self.name = auth['info']['name'] || ""
    end
    self.save
  end

  def self.load_all_reactions
    User.all.each do |user|
      user.load_reactions_data
    end
  end

  def self.save_all_last_activities
    User.all.each do |user|
      user.save_last_activity
    end
  end

  def save_last_activity
    self.last_activity_at = get_last_activity
    save
  end

  def get_last_activity
    last_reaction = self.slack_reactions_data.first
    puts last_reaction.inspect
    unless last_reaction.nil?
      if last_reaction["type"] == "mesage"
        return Time.at last_reaction["message"]["ts"].to_i
      elsif last_reaction["type"] == "file"
        return Time.at last_reaction["file"]["timestamp"].to_i
      else
        return Time.at last_reaction["message"]["ts"].to_i        
      end
    end
  end

  def load_reactions_data
    self.slack_reactions_data = get_reations
    self.slack_reactions_data_updated_at = Time.now
    self.save
  end

  def get_reations
    slack_client.reactions_list("user"=>self.uid)["items"]
  end

  def load_coworkers
    get_coworkers.each do |coworker|
      u = User.where(:uid=>coworker["id"]).first_or_create
      u.provider = "slack"
      u.slack_api_data = coworker
      u.slack_api_data_updated_at = Time.now
      u.name = coworker["name"]
      u.team_slack_id = self.team_slack_id
      u.team_name = self.team_name
      u.team_domain = self.team_domain
      u.save
    end
  end

  def get_coworkers
    slack_client.users_list["members"]
  end

  def slack_client
    Slack::Web::Client.new(:token=>slack_token)
  end

  def is_deleted?
    slack_api_data["deleted"]
  end

  private

  def slack_token
    u = User.where("slack_auth_data is not null").first
    u.slack_auth_data['credentials']['token']
  end

end
