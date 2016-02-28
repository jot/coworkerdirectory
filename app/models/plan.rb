class Plan < ActiveRecord::Base
  has_many :subscriptions

  include Koudoku::Plan
  
end
