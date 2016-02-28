class Answer < ActiveRecord::Base

  after_save :ask_question

  belongs_to :user
  belongs_to :question

  #property_name

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
