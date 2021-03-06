class Datafile

  def self
  end
  
    
  def self.handleUserDataSubmission(platform, user, email, institute, insUrl, logo, userfile,sampledcovfile)
    valMsg = "success" ## for validation response
      
    ## save the user uploaded files first
    self.uploadUserFile(userfile)
    self.uploadUserFile(sampledcovfile)
    self.uploadUserLogo(logo)
    ## write information regarding this submission
    self.writeUserInformation(platform, user, email, institute, insUrl,userfile.original_filename,sampledcovfile.original_filename)
    
    return valMsg
  end  
 
  def self.uploadUserFile(filetoSave)
    ## save uploaded file 
    File.open(Rails.root.join('uploads',filetoSave.original_filename), 'w') do |file|
      file.write(filetoSave.read)
    end
    return true
  end 
  
  def self.uploadUserLogo(logotoSave)
    ## save uploaded logo
    File.open(Rails.root.join('uploadlogos',logotoSave.original_filename),'wb') do |iostream|
      iostream.write(logotoSave.read)
    end 
    return true
  end 

  def self.writeUserInformation(platform, username, email, institute, insurl,filename,sampledcovfilename)
    ## open file handler
    File.open(Rails.root.join('uploads',institute), 'w') do |file|
      file.write("Username :: " + username+"\n")
      file.write("User email :: " +  email+"\n")
      file.write("User institute :: " + institute+"\n")
      file.write("User institute Url :: " + insurl+"\n")
      file.write("Platform :: " + platform +"\n")
      file.write("vcf file :: " + filename +"\n")
      file.write("sample dcov file :: " + sampledcovfilename +"\n")
      file.write("Local request timestamp :: " + Time.now().to_s() +"\n")      
    end
    return true
  end
  
 
end