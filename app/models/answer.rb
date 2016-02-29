class Answer < ActiveRecord::Base

  include Twitter::Autolink

  after_save :ask_question

  belongs_to :user
  belongs_to :question

  #property_name

  def self.check_for_url_or_twitter
    Answer.all.each do |a|
      a.check_for_url_or_twitter
    end
  end

  def background_image

  end

  def color

  end

  def image_url

  end

  def check_for_url_or_twitter
    t = unescaped_answer
    unless t.nil?
      u = URI::extract(auto_link(t)).first
      unless u.blank?
        self.url = u
        self.save
      end
    end
  end


  def unescaped_answer
    unless answer_text.nil?
      CGI.unescapeHTML(answer_text.gsub(/[“”]/, '"')
        .gsub(/[‘’]/, "'")
        .gsub(/<(?<sign>[?@#!]?)(?<dt>.*?)>/) do |match|
          sign = $~[:sign]
          dt = $~[:dt]
          rhs = dt.split('|', 2).first
          case sign
          when '@', '!'
            "@#{User.find_by_uid(rhs).name}"
          when '#'
            "##{rhs}"
          else
            rhs
          end
        end)
    end
  end


  def self.ask_stand_alone_question(user, text, property_name)
    a = Answer.create(:user_id=>user.id, :question_text=>text, :property_name=>property_name)
    # m = user.send_im(text)
    # a.question_message_id = m.id
    # a.question_text = m.text
    # a.asked_at = Time.now
    # a.save
  end

  def ask_question
    if question_message_id.nil?
      if self.question_text.nil?
        m = user.send_im(question.text)
      else
        m = user.send_im(self.question_text)
      end
      self.question_message_id = m.id
      self.question_text = m.text
      self.asked_at = Time.now
      self.save
    end
  end

  def receive_answer(message)
    if answer_message_id.nil?
      self.answer_message_id = message.id
      self.answer_text = message.text
      self.answered_at = Time.now
      self.save
      m = user.send_im(question.response) unless question.nil? || question.response.nil?
    end
  end


end
