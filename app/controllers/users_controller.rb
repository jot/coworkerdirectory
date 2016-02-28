class UsersController < ApplicationController
  # before_action :authenticate_user!, :except => [:index]
  # before_action :correct_user?, :except => [:index]

  def index
    # @team = Team.where(domain: request.subdomain).first
    if current_team.nil?
      redirect_to root_url(:subdomain=>"")
    else
      @users = current_team.members_list

    end
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
    @user = current_team.users.find_by_name(params[:id])
    # authorize @user
  end

  private

  def secure_params
    params.require(:user).permit(:photo_score)
  end

end
