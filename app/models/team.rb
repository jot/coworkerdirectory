class Team < ActiveRecord::Base
# Added by Koudoku.
  has_one :subscription

# Added by Koudoku.
  has_one :subscription
  has_many :channels
  has_many :questions
  has_many :presences

  has_many :messages, foreign_key: :team_uid, primary_key: :uid
  has_many :users, foreign_key: :team_uid, primary_key: :uid#, class_name: "User"

  belongs_to :user


  def notify_inuda
    t = Team.find_by_domain("inuda")
    t.notify_admin("#{self.domain}.cabinbot.com created by #{self.admin_name} (#{self.admin_email})")
  end

  def notify_admin(message)
    send_im(self.user_uid, message)
  end

  def admin
    user
  end

  def admin_name
    user.name
  end

  def admin_email
    user.email
  end


  def members_list
    users.find(presences.last.active_ids)
    # users.order('photo_score DESC NULLS LAST').order('last_activity_at DESC NULLS LAST')
  end


  def load_questions
    Question.load_questions(self)
  end

  def general_channel
    channels.where("slack_data @> ?",{is_general: true}.to_json).first
  end

  def post_to_general(message, image_url=nil)
    if image_url.present?
      attachments = [{"fallback":"A fun gif", "image_url": image_url}]
    end
    Message.create_from_slack_data(slack_client.chat_postMessage(channel: general_channel.uid, text: message, as_user: true, attachments: attachments), self.uid)
  end

  def send_im(user_uid, message)
    im = slack_client.im_open(user: user_uid)
    Message.create_from_slack_data(slack_client.chat_postMessage(channel: im["channel"]["id"], text: message, as_user: true), self.uid)
  end

  def members
    users
  end

  def coworkers
    users
  end

  def slack_client
    Slack::Web::Client.new(:token=>bot_access_token)
  end

  def slack_client_user
    user.slack_client_user
  end


  def load_users
    get_users.each do |user|
      u = User.where(:uid=>user["id"]).first_or_create
      u.provider = "slack"
      u.slack_api_data = user
      u.slack_api_data_updated_at = Time.now
      u.name = user["name"]
      u.team_uid = self.uid
      u.team_name = self.name
      u.team_domain = self.domain
      u.save
    end
  end

  def get_users
    slack_client.users_list["members"]
  end

  def self.check_presences
    Team.all.each do |t|
      t.check_presence
    end
  end

  def check_presence
    data = slack_client.users_list("presence"=>1)
    active_uids = data["members"].map {|m| m["id"] if m["presence"] == "active"}.compact
    away_uids = data["members"].map {|m| m["id"] if m["presence"] != "active"}.compact
    active_ids = User.where(:uid=>active_uids).pluck(:id)
    away_ids = User.where(:uid=>active_uids).pluck(:id)
    Presence.create(:team_id=>self.id, :team_uid=>self.uid, :checked_at=>Time.now, :slack_api_data=>data,
                    :active_uids=>active_uids, :away_uids=>away_uids, :active_ids=>active_ids, :away_ids=>away_ids)
  end

  def self.update_all_data
    Team.all.each do |t|
      Resque.enqueue(UpdateTeamData, t.uid)
    end
  end

  def load_channels
    slack_client.channels_list["channels"].each do |channel_item|
      Channel.where(uid: channel_item["id"], team_id: self.id).first_or_create do |channel|
        channel.name = channel_item["name"]
        channel.created = channel_item["created"]
        channel.creator = channel_item["creator"]
        channel.is_archived = channel_item["is_archived"]
        channel.is_member = channel_item["is_member"]
        channel.num_members = channel_item["num_members"]
        channel.slack_data = channel_item
      end
    end
  end

end
