class ApplicationController < ActionController::Base
  protect_from_forgery
  protected

  #This method is for preventing users to access confidential pages withuot logging in 
  def authenticate_user
    if session[:user]
      return true
    else
      redirect_to(:controller => 'gapp', :action => 'home')
      # set current_user by the current user object
      #@current_user = User.find session[:user] 
      return false
    end
  end

  #This method is for preventing users to access Account Request & Login Page without logout
  def save_login_state
    if session[:user]
      redirect_to(:controller => 'gapp', :action => 'home')
      return false
    else
      return true
    end
  end

  ##Admin method to create new user
  def adminCreateUser
    admintIP = request.remote_ip
    if session[:user] == 'geevsAdmin'
      return true
    else
      redirect_to(:controller => 'users', :action => 'accountRequest')
      return false
    end    
  end

end
