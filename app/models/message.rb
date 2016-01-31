class Message < ActiveRecord::Base

  def self.create_from_slack_data(data, team_uid=nil)
    team_uid ||= data["team"]
    Message.where(ts: data["ts"], channel_uid: data["channel"], team_uid: team_uid).first_or_create do |message|
      message.timestamp = Time.at(data["ts"].split(".")[0].to_i)
      message.slack_data = data

      data_message = data["message"]
      data_message ||= data
      message.message_type = data_message["type"]
      message.message_subtype = data_message["subtype"]
      message.user_uid = data_message["user"]
      message.text = data_message["text"]
    end
  end

end
