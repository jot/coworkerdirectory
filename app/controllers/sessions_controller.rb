class SessionsController < ApplicationController

  def new
    redirect_to '/auth/slack'
  end

  def create
    auth = request.env["omniauth.auth"]
    # raise
    user = User.where(:provider => auth['provider'],
                      :uid => auth['uid'].to_s).first || User.create_with_omniauth(auth)
    user.update_team
    Resque.enqueue(SetUpNewTeam, user.team_uid)
    reset_session
    session[:user_id] = user.id
    redirect_to working_url
    # redirect_to root_url(subdomain: user.team.domain), :notice => 'Signed in!'
  end

  def destroy
    reset_session
    redirect_to root_url, :notice => 'Signed out!'
  end

  def failure
    redirect_to root_url, :alert => "Authentication error: #{params[:message].humanize}"
  end

end