class Enquiry < ActiveRecord::Base

  belongs_to :user

  after_commit :on => :create do
    SendEnquiryJob.perform_later(self)
  end

  validates :name, presence: true
  validates :email, presence: true, email: true
  validates :text, presence: true

  def team
    user.team
  end

  def user_name
    user.full_name
  end

end
