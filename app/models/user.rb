class User
  

  def self
    con = Mysql.connect('www.ediva.crg.eu', 'geevsUser', 'geevspublic', 'GEEVSUser')
    return con
  end
  
  
  ## create new user
  def self.createSubmituser(username,email,pass)
    
    ## check email in the database
    qryEmail = "select * from Table_users where email = '"+ email +"';"
    ccU = User.new.self
    refEmail = ccU.query(qryEmail)

    if refEmail.num_rows != 0
      return "email"
    else
      ##check for username validity in the database
      qryUser = "select * from Table_users where username = '"+ username+"';"
      refUser = ccU.query(qryUser)

      if refUser.num_rows != 0
        return "usr"
      else
        ## lets add salt to password and create a new pass
        (pass,salt) = encrypt_password(pass)
      
        qry = "insert into Table_users values('"+ username+"','"+ email +"','"+ pass+"','"+ salt+"')"
        #qry = "insert into Table_users values('"+ username+"','"+ email +"','"+ pass+"','puta');"
    
        cc = User.new.self
        cc.query(qry)
        cc.close
        ## clear password    
        pass = nil
    
        ## return message
        return "success"      
      end
      
    end
    
    ccU.close
  end
    
  ## encrypt_password
  def self.encrypt_password(password)
    salt = ""
    encrypted_password = ""
    unless password.blank?
      salt = BCrypt::Engine.generate_salt
      encrypted_password = BCrypt::Engine.hash_secret(password, salt)
    end
    return encrypted_password,salt
  end
  
  ## validate saved user for login
  def self.validateUser(login_username,login_password)
  
    dbpass = ""
    dbsalt = ""

    qry = "select password,salt from Table_users where username = '"+ login_username +"';"

    cc = User.new.self
    usermysqlref = cc.query(qry)
    cc.close
    
    usermysqlref.each do |r1,r2|
      dbpass = r1
      dbsalt = r2
    end
    
    if (dbsalt != '')
      ## lets add salt to password to match in the database
      passnewtomatch = BCrypt::Engine.hash_secret(login_password,dbsalt)    
      if (passnewtomatch == dbpass)
        return "validuser"
      else
        return "invaliduser"
      end
    else
      return "invaliduser"
    end            
  end
  
end