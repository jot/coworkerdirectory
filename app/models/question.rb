class Question < ActiveRecord::Base

  belongs_to :team
  has_many :answers

  def self.load_questions(team)
    questions = YAML::load_file("#{Rails.root}/data/questions.yml")
    questions.each do |q|
      t = q["text"].gsub("{{TEAM}}", team.name)
      r = q["response"].gsub("{{TEAM}}", team.name)
      Question.create(team_id:team.id, text:t, response:r, priority:q["priority"])
    end
  end

end
