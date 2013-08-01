class UsersController < ApplicationController

  ## SignUp form for new user
  def newUser
  end

  ## create new user
  def create
    ## check signup parameter values
    if (params[:username] == "" or params[:email]=="" or params[:password]=="" or params[:password_confirmation]=="")
      redirect_to :newUser
      flash[:notice] = "You should complete all the fields !"
      flash[:color]= "invalid"
    elsif (! params[:email] =~ /^[A-Z0-9._%+-]+\@[A-Z0-9.-]+\.[A-Z]{2,4}/) ## initial check for valid email address format
      redirect_to :newUser
      flash[:notice] = "Not a valid email format !"
      flash[:color]= "invalid"
    elsif (params[:password].length < 6)
      redirect_to :newUser
      flash[:notice] = "Password too small !"
      flash[:color]= "invalid"
    elsif (params[:password].length > 20)
      redirect_to :newUser
      flash[:notice] = "Password too big !"
      flash[:color]= "invalid"      
    elsif (params[:password] != params[:password_confirmation]) ## checking for password and password confirmation match
      redirect_to :newUser
      flash[:notice] = "Password and password confirmation mismatch ! Carefully enter again !!"
      flash[:color]= "invalid"
    else
      @msg = User.createSubmituser(params[:username],params[:email],params[:password])
    end
    
   if (@msg == "email")
      redirect_to :newUser
      flash[:notice] = "Email already exists in the database ! If you have forgotten your password contact GEEVS team !!"
      flash[:color]= "invalid"
    elsif (@msg == "usr")
      redirect_to :newUser
      flash[:notice] = "Username alreadt taken ! Try again !!"
      flash[:color]= "invalid"
    elsif (@msg == "success")
      redirect_to :newUser
      flash[:notice] = "Successfully new user has been created ! Please login to submit data !!"
      flash[:color]= "valid"
    else
    end    
  end
  
  ## login
  #def login
    
  #end
  
  def authenticateUser
    valmsg = User.validateUser(params[:login_username],params[:login_password])
    if (valmsg == 'validuser')
      session[:user] = params[:login_username]
      redirect_to :controller => "gapp", :action => "home"
    else
      redirect_to :root
      flash[:notice] = "Username & password mismatch ! Please try again !!"
      flash[:color]= "invalid"
    end
  end
  
  def logout     
    session[:user] = nil
    redirect_to :newUser
  end

end