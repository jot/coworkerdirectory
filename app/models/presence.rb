class Presence < ActiveRecord::Base

  def active_members
    User.where(:id=>active_ids)
  end

end
