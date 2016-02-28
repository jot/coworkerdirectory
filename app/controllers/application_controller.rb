class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_team
  helper_method :current_user
  helper_method :user_signed_in?
  helper_method :correct_user?

  # if Rails.env.development?
  #     # https://github.com/RailsApps/rails-devise-pundit/issues/10
  #     include Pundit
  #     # https://github.com/elabs/pundit#ensuring-policies-are-used
  #     after_action :verify_authorized,  except: :index
  #     after_action :verify_policy_scoped, only: :index

  #     rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  #     private
  #     def user_not_authorized
  #       flash[:alert] = "Access denied." # TODO: make sure this isn't hard coded English.
  #       redirect_to (request.referrer || root_path) # Send them back to them page they came from, or to the root page.
  #     end
  # end


  private
    def current_user
      begin
        @current_user ||= User.find(session[:user_id]) if session[:user_id]
      rescue Exception => e
        nil
      end
    end

    def current_team
      Team.where(domain: request.subdomain).first
      # current_user.team unless current_user.nil?
    end

    def user_signed_in?
      return true if current_user
    end

    def correct_user?
      @user = User.find(params[:id])
      unless current_user == @user
        redirect_to root_url, :alert => "Access denied."
      end
    end

    def authenticate_user!
      if !current_user
        redirect_to root_url, :alert => 'You need to sign in for access to this page.'
      end
    end

end
