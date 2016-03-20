class Message < ActiveRecord::Base

  belongs_to :team, foreign_key: :team_uid, primary_key: :uid
  belongs_to :channel, foreign_key: :channel_uid, primary_key: :uid
  belongs_to :user, foreign_key: :user_uid, primary_key: :uid
  has_one :answer, foreign_key: :answer_message_id

  def self.create_from_slack_data(data, team)
    logger.info "CREATING MESSAGE"
    m = Message.where(ts: data["ts"], channel_uid: data["channel"], team_id: team.id, team_uid: team.uid).first_or_create do |message|
      message.timestamp = Time.at(data["ts"].split(".")[0].to_i)
      message.slack_data = data
      data_message = data["message"]
      data_message ||= data
      message.message_type = data_message["type"]
      message.message_subtype = data_message["subtype"]
      message.user_uid = data_message["user"]
      message.text = data_message["text"]
    end
    return m
  end

  def reply(text)
    puts "Sending to #{channel_uid}: #{text}"
    team.send_message(channel_uid,text)
  end

  def answer_question
    puts "ANSWERING QUESTION"
    user.answer_question(self)
  end

  def is_positive?
    ['continue', 'y', 'yes', 'yea', 'yeah', 'yep', 'OK', 'ok',  'affirmative', 'aye', 'roger', 'yup', 'yuppers', 'ja', 'surely', 'amen', 'totally', 'yessir'].include?(self.text)
  end

  def is_negative?
    ['n', 'no', 'nope', 'nay'].include?(self.text)
  end


end
