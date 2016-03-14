class SessionsController < ApplicationController

  def new
    if params[:team]
      redirect_to "/auth/slack?team=#{params[:team]}&scope=#{params[:scope]}"
    else
      redirect_to '/auth/slack'      
    end
  end

  def create
    auth = request.env["omniauth.auth"]
    # raise
    user = User.where(:provider => auth['provider'],
                      :uid => auth['uid'].to_s).first || User.create_with_omniauth(auth)
    if user.team.nil?
      user.update_team
    end
    reset_session
    session[:user_id] = user.id
    if user.team.channels.empty?
      redirect_to working_url
    else
      redirect_to root_url(subdomain: user.team.domain), :notice => 'Signed in!'
    end
  end

  def destroy
    reset_session
    redirect_to root_url, :notice => 'Signed out!'
  end

  def failure
    redirect_to root_url, :alert => "Authentication error: #{params[:message].humanize}"
  end

end