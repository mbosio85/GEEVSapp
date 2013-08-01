class ApplicationController < ActionController::Base
  protect_from_forgery
  protected

  def authenticate_user
    if session[:user]
      return true
    else
      redirect_to(:controller => 'users', :action => 'newUser')
      # set current_user by the current user object
      #@current_user = User.find session[:user] 
      return false
    end
  end

  #This method for prevent user to access Signup & Login Page without logout
  def save_login_state
    if session[:user]
      redirect_to(:controller => 'users', :action => 'login')
      return false
    else
      return true
    end
  end

end
