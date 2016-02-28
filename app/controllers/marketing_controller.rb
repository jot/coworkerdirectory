class MarketingController < ApplicationController

  def index
    render layout: 'home'    
  end

  def plans
    render layout: 'marketing' 
  end

  def terms
    render layout: 'marketing' 
  end

  def privacy
    render layout: 'marketing' 
  end


end
