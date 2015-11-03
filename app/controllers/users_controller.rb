class UsersController < ApplicationController
  before_action :authenticate_user!, :except => [:index]
  before_action :correct_user?, :except => [:index]

  def index
    @team = User.where(team_domain: request.subdomain).first

    @users = @team.coworkers.order('photo_score DESC NULLS LAST').order('last_activity_at DESC NULLS LAST')
    # authorize User
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(secure_params)
      redirect_to users_path
    else
      render :edit
    end
  end

  def show
    @user = User.find(params[:id])
    # authorize @user
  end

  private

  def secure_params
    params.require(:user).permit(:photo_score)
  end

end
