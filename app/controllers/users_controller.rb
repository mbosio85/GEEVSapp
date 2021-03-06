class UsersController < ApplicationController

  before_filter :save_login_state, :only => [:accountRequest, :accountRequestHandler]
  before_filter :adminCreateUser, :only => [:newUser, :create, :showRequest]
  
  ## SignUp form for new user
  def newUser
  end

  ## Account request
  def accountRequest
  end

  def accountRequestHandler
    ## get clinet ip address
    clientIp = request.remote_ip
    
    ## check user attemp by user ip address
    valmsg = User.requestaccountattemptValidation(clientIp)
    ## take action based on returned message
    if valmsg == "1"
      redirect_to :accountRequest
      flash[:notice] = "You have already requested for an account ! GEEVS team will contact you soon !!"
      flash[:color]= "invalid"
      return       
    else
    ## check signup parameter values
    if (params[:username] == "" or params[:email]=="" or params[:institute]=="")
      redirect_to :accountRequest
      flash[:notice] = "You should complete all the fields !"
      flash[:color]= "invalid"
      return
    elsif ( params[:email] !~ /^[a-zA-Z0-9._%+-]+\@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/ ) ## initial check for valid email address format
      redirect_to :accountRequest
      flash[:notice] = "Not a valid email format ! Be sure to provide an email that you check frequently !!"
      flash[:color]= "invalid"
      return
    else
      msg = User.handleAccountRequest(params[:username],params[:email], params[:institute], clientIp)
    end      
    
    if msg == "success"
      redirect_to :accountRequest
      flash[:notice] = "Successfully account request submitted ! GEEVS team will contact you soon !!"
      flash[:color]= "valid"      
    #elsif msg == "fail"
    else
      redirect_to :accountRequest
      flash[:notice] = "You have already requested for an account ! GEEVS team will contact you soon !!"
      flash[:color]= "invalid"
      return      
    end
  end

  end

  ## show request
  def showRequest
    
  end

  ## create new user
  def create
    ## check signup parameter values
    if (params[:username] == "" or params[:email]=="" or params[:password]=="" or params[:password_confirmation]=="")
      redirect_to :newUser
      flash[:notice] = "You should complete all the fields !"
      flash[:color]= "invalid"
    elsif (params[:email] !~ /^[a-zA-Z0-9._%+-]+\@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/) ## initial check for valid email address format
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
      @msg = User.createSubmituser(params[:username],params[:email],params[:password],params[:signature])
    end
    
   if (@msg == "sig")
      redirect_to :newUser
      flash[:notice] = "Admin Signature Failure !!"
      flash[:color]= "invalid"      
   elsif (@msg == "email")
      redirect_to :newUser
      flash[:notice] = "Email already exists in the database ! If you have forgotten your password contact GEEVS team !!"
      flash[:color]= "invalid"
    elsif (@msg == "usr")
      redirect_to :newUser
      flash[:notice] = "Username already taken ! Try again !!"
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
    redirect_to :home
  end

end