class Subscription < ActiveRecord::Base
  include Koudoku::Subscription

  
  belongs_to :team
  belongs_to :coupon

end
