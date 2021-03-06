class User < ActiveRecord::Base
  enum role: [:user, :vip, :admin]
  after_initialize :set_default_role, :if => :new_record?

  has_many :answers


  def full_name
    t = clearbit_data["person"]["name"]["fullName"] unless clearbit_data.nil? || clearbit_data["person"].nil? || clearbit_data["person"]["name"].nil?
    t
  end

  def bio
    t = clearbit_data["person"]["bio"] unless clearbit_data.nil? || clearbit_data["person"].nil? || clearbit_data["person"]["bio"].nil?
    t ||= slack_api_data["profile"]["title"]
    t
  end


  def twitter_handle
    t = clearbit_data["person"]["twitter"]["handle"] unless clearbit_data.nil? || clearbit_data["person"].nil? || clearbit_data["person"]["twitter"].nil?
    t
  end

  def facebook_handle
    t = clearbit_data["person"]["facebook"]["handle"] unless clearbit_data.nil? || clearbit_data["person"].nil? || clearbit_data["person"]["facebook"].nil?
    t
  end

  def linkedin_handle
    t = clearbit_data["person"]["linkedin"]["handle"] unless clearbit_data.nil? || clearbit_data["person"].nil? || clearbit_data["person"]["linkedin"].nil?
    t
  end

  def github_handle
    t = clearbit_data["person"]["github"]["handle"] unless clearbit_data.nil? || clearbit_data["person"].nil? || clearbit_data["person"]["github"].nil?
    t
  end

  def company_twitter_handle
    clearbit_data["company"]["twitter"]["handle"] unless clearbit_data.nil? || clearbit_data["company"].nil? || clearbit_data["company"]["twitter"].nil?
  end

  def company_facebook_handle
    clearbit_data["company"]["facebook"]["handle"] unless clearbit_data.nil? || clearbit_data["company"].nil? || clearbit_data["company"]["facebook"].nil?
  end

  def company_linkedin_handle
    clearbit_data["company"]["linkedin"]["handle"] unless clearbit_data.nil? || clearbit_data["company"].nil? || clearbit_data["company"]["linkedin"].nil?
  end

  def company_github_handle
    clearbit_data["company"]["github"]["handle"] unless clearbit_data.nil? || clearbit_data["company"].nil? || clearbit_data["company"]["github"].nil?
  end

  def company_name
    clearbit_data["company"]["name"] unless clearbit_data.nil? || clearbit_data["company"].nil?
  end

  def company_site
    clearbit_data["company"]["site"]["url"] unless clearbit_data.nil? || clearbit_data["company"].nil? || clearbit_data["company"]["site"].nil?
  end

  def site
    w = clearbit_data["person"]["site"] unless clearbit_data.nil? || clearbit_data["person"].nil? || clearbit_data["person"]["site"].nil?
    w
  end

  def logo
    clearbit_data["company"]["logo"] unless clearbit_data.nil? || clearbit_data["company"].nil?
  end
  
  def get_clearbit(force=false)
    if self.clearbit_data.nil? || force
      unless self.email.blank?
        result = Clearbit::Enrichment.find(email: email, stream: true)
        if result.present? && (result.person || result.company)
          self.clearbit_data = result
          self.save
        end
      end
    end
  end


  def get_score
    if is_bot?
      self.score = -1000
    else
      self.score = 0
      self.score = self.score + 10 if full_name.present?
      self.score = self.score + 20 if bio.present?
      self.score = self.score + 10 if site.present?
      if image_url.present? && image_url2.present? && image_url != image_url2
        self.score = self.score + 10
      end
      if twitter_handle.present? || facebook_handle.present? || linkedin_handle.present? || github_handle.present?
        self.score = self.score + 10
      end
      unless presences.nil?
        self.score = self.score + presences.where("created_at > ?", 1.month.ago.at_beginning_of_day).select("date_trunc('day', created_at)").distinct.count
      end
      unless answered_questions.empty?
        self.score = self.score + answered_questions.where("created_at > ?", 1.month.ago.at_beginning_of_day).count
      end

      self.score = self.score - 20 if clearbit_data.present? && clearbit_data["person"].present? && ["male","Male"].include?(clearbit_data["person"]["gender"])
    end
    self.save
  end

  def presences
    team.presences.where("active_ids @> ?",[self.id].to_json) unless team.nil?
  end

  def presence_counts(since=Time.parse("2016-02-01"))
    presences.where("created_at > ?", since).group("date_trunc('day', created_at)").order("date_trunc('day', created_at
)").count
  end

  def answered_questions
    answers.where.not(:answer_text=>nil).order(:created_at)
  end

  def answered_questions_no_url
    answered_questions.where(:url=>nil)
  end

  def answered_questions_with_url
    answered_questions.where.not(:url=>nil)
  end

  def email
    e = slack_api_data["profile"]["email"] unless slack_api_data.nil? || slack_api_data["profile"].nil?
    e ||= slack_auth_data["info"]["email"] unless slack_auth_data.nil? || slack_auth_data["info"].nil?
    e
  end

  def gravatar
    Gravatar.new(email).image_url
  end


  def questions
    team.questions.where.not(:id=>answered_questions.pluck(:question_id))
  end

  def ask_stand_alone_question(question_text, property_name=nil)
    Answer.ask_stand_alone_question(self, question_text, property_name)
  end

  def create_welcome_messages
    if self.private_welcome_messages.blank?
      self.private_welcome_messages = []
      if self.is_cabinbot_admin?
        self.private_welcome_messages << {:text=>"Thank you for trying Cabinbot. You’re going to love the things I can do for your community.", :message_id=>nil}
        self.private_welcome_messages << {:text=>"I’m not going to contact any other members until you give me the go ahead. And when I do start contacting them I’ll start with only the members you tell me to contact.", :message_id=>nil}
        self.private_welcome_messages << {:text=>"Before we begin, here’s a quick question:", :message_id=>nil}
        self.private_welcome_messages << {:question=>"Why did you decide to add me to your Slack team today?", :property_name=>"why", :answer_id=>nil, :message_id=>nil}
        self.private_welcome_messages << {:text=>"I'll try my very best to meet your expectations"}
        self.private_welcome_messages << {:text=>"If you have a look at http://#{team.domain}.cabinbot.com You’ll see a directory of all your members. Right now it can only be seen by people who are members of your Slack team... And it’s looking a little bare...", :message_id=>nil}
        self.private_welcome_messages << {:confirm=>"Want to do something about that?", :message_id=>nil, :confirmed_at=>nil}
        self.private_welcome_messages << {:text=>"Great! Before I contact anyone I need you to lead by example...", :message_id=>nil}
        self.private_welcome_messages << {:text=>"What happens next is what I hope to do for all your members. Please stick with it. It’ll be worth it - I promise.", :message_id=>nil}
        self.private_welcome_messages << {:confirm=>"Ready?", :message_id=>nil, :confirmed_at=>nil}
      end
      self.private_welcome_messages << {:text=>"Ahoy there. I'm Cabinbot."}
      self.private_welcome_messages << {:text=>"I hope things are going well for you as a member of #{team.name}."}
      self.private_welcome_messages << {:text=>"@#{team.admin_name} asked me to say hello and run a few things past you..."}
      self.private_welcome_messages << {:question=>"First up: Where on the web should members of #{team.name} go to learn a little more about you? (Website/Twitter URL/LinkedIn page)", :property_name=>"url"}
      self.private_welcome_messages << {:text=>"I have 20 more questions for you. I’ll use your answers to help you meet some other members of #{team.name}. We have a bunch of people here who I think you’ll get on swimmingly with."}
      self.private_welcome_messages << {:confirm=>"Are you happy to answer them now?"}
      self.save
    end
  end

  def last_welcome_message
    last = nil
    self.private_welcome_messages.each_index do |index|
      if self.private_welcome_messages[index]["completed_at"].nil?
        return last
      end
      last = index
    end
    return last
  end

  def next_welcome_message
    self.private_welcome_messages.each_index do |index|
      if self.private_welcome_messages[index]["completed_at"].nil?
        return index
      end
    end
    return nil
  end

  def continue_welcome
    index = self.next_welcome_message
    if index.nil?
      answer_next_question
    else
      if self.private_welcome_messages[index]["text"].present?
        message = send_im(self.private_welcome_messages[index]["text"])
        self.private_welcome_messages[index]["message_id"] = message.id
        self.private_welcome_messages[index]["completed_at"] = Time.now
        self.save
        self.continue_welcome
      elsif self.private_welcome_messages[index]["question"].present?
        if self.private_welcome_messages[index]["answer_id"].nil?
          answer = ask_stand_alone_question(self.private_welcome_messages[index]["question"],self.private_welcome_messages[index]["property_name"])
          self.private_welcome_messages[index]["answer_id"] = answer.id
          self.private_welcome_messages[index]["message_id"] = answer.question_message_id
          self.save
        end
      elsif self.private_welcome_messages[index]["confirm"].present?
        message = send_im(self.private_welcome_messages[index]["confirm"])
        self.private_welcome_messages[index]["message_id"] = message.id
        self.save
      end
    end
  end

  def answer_question(message)
    answer = answers.where(:answer_message_id=>nil).order(:asked_at=>:desc).first
    if answer.present?
      puts "found answer"
      answer.receive_answer(message)
      if answer.question_id.nil?
        index = self.next_welcome_message
        if index.present? && self.private_welcome_messages[index].present? && self.private_welcome_messages[index]["question"].present?
          self.private_welcome_messages[index]["completed_at"] = Time.now
          self.save
          continue_welcome
        end
      else
        answer_next_question
      end
    else
      puts "no answer"
    end
  end

  def positive_response
    index = next_welcome_message
    if index.nil?
      continue_welcome
    elsif self.private_welcome_messages[index]["confirm"].present?
      self.private_welcome_messages[index]["completed_at"] = Time.now
      self.save
      continue_welcome
    end
  end

  def negative_response
    send_im("No worries. Just say 'continue' when you are ready.")
  end

  def answer_next_question
    if questions.empty?
      send_im("That’s it! I’ll leave you to getting on with meeting other members on your own for a bit. Keep an eye out for more messages from me in a few days. I’ll let you know if anyone asks about working with you and if I spot another member you should meet.")
      sleep(3)
      send_im("Oh and you now have a lovely looking profile at: #{team.domain}.cabinbot.com/users/#{name}")
    else
      a = Answer.create(:user_id=>self.id, :question_id=>questions.first.id)
      a.ask_question
    end
  end

  def to_param
    name
  end

  def description
    slack_api_data["profile"]["title"]
  end

  def channels
    Channel.list_for(uid)
  end

  def color
    slack_api_data["color"] ? slack_api_data["color"] : "#ffffff"
  end

  def background_image
    nil
  end

  def coworkers
    team.coworkers
  end

  def set_default_role
    if User.count == 0
      self.role ||= :admin
    else
      self.role ||= :user
    end
  end

  def full_name
    self.slack_api_data["profile"]["real_name"] unless slack_api_data.nil?
  end

  def image_url
    unless slack_api_data.nil?
      return slack_api_data["profile"]["image_original"] unless  slack_api_data["profile"]["image_original"].blank?
      return slack_api_data["profile"]["image_192"]
    end
  end

  def image_url2
    t = clearbit_data["person"]["avatar"] unless clearbit_data.nil? || clearbit_data["person"].nil?
    t ||= image_url
    t
  end

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth['provider']
      user.uid = auth['uid']
      user.slack_auth_data = auth
      user.slack_auth_data_updated_at = Time.now
      user.team_uid = auth['info']['team_id']
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

  def self.get_all_scores
    User.all.each do |user|
      user.get_score
    end
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


  def slack_client_user
    Slack::Web::Client.new(:token=>slack_token)
  end


  def slack_client
    Slack::Web::Client.new(:token=>slack_bot_token)
  end


  def rtm_slack_client
    Slack::RealTime::Client.new(:token=>slack_bot_token)
  end

  def is_cabinbot_admin?
    team.admin.uid == self.uid
  end

  def is_deleted?
    slack_api_data["deleted"] unless slack_api_data.nil?
  end

  def slack_bot_token
    team.bot_access_token
  end

  def slack_bot_user_id
    team.bot_user_id
  end

  def send_im(text, attachments = [])
    im = slack_client.im_open(user: uid)
    team.create_message_from_slack_data(slack_client.chat_postMessage(channel: im["channel"]["id"], text: text, as_user: true, parse: "full", attachments: attachments))
  end



  def team
    Team.find_by_uid(team_uid)
  end

  def update_team
    team_data = slack_client_user.team_info

    team_is_new = false

    t = Team.where(uid: team_uid).first_or_create do |new_team|
      team_is_new = true
      new_team.user_id = self.id
      new_team.user_uid = self.uid
      new_team.bot_user_id = slack_auth_data["extra"]["bot_info"]["bot_user_id"] unless slack_auth_data["extra"]["bot_info"].nil?
      new_team.bot_access_token = slack_auth_data["extra"]["bot_info"]["bot_access_token"] unless slack_auth_data["extra"]["bot_info"].nil?
    end

    t.name = team_data["team"]["name"]
    t.domain = team_data["team"]["domain"]
    t.email_domain = team_data["team"]["email_domain"]
    t.slack_data = team_data
    t.save
    if team_is_new
      Resque.enqueue(SetUpNewTeam, team_uid)
    end

  end

  def is_bot?
    slack_api_data["is_bot"] unless slack_api_data.nil?
  end

  def active_users
    slack_client_user.users_list(:presence=>1)["members"].select{|u| u["presence"]=="active"}
  end

  def invite(email)
    slack_client_user.post("users.admin.invite",:email=>email)
  end

  def invite_bot_to_general
    slack_client_user.channels_invite(:channel=>team.general_channel.uid,:user=>team.bot_user_id)
  end

  private

  def slack_token
      slack_auth_data['credentials']['token']
  end

end
