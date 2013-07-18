class GappController < ApplicationController

  ## helper methods declaration
  ##helper_method :sort_column, :sort_direction


  ## home function
  def home
    @chr = ['1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','X','Y','MT']
  end

  ## search variants by chr and pos
  def search_chr_pos
    ## validation appropriate fields and then query the model
    if (params[:chromosome] == "")
      redirect_to :action => "home"
      flash[:notice] = "You must select a Chromosome !"
      flash[:color]= "invalid"
    elsif (!(params[:start_pos] =~ /\d/) or !(params[:end_pos] =~ /\d/) or params[:end_pos].length > 11 or params[:start_pos].length > 11 or (params[:end_pos] < params[:start_pos]))
      redirect_to :action => "home"
      flash[:notice] = "Wrong Position Values !"
      flash[:color]= "invalid"
    elsif(!(params[:af] == "") and !(params[:af] =~ /^\<\>(\s)*[01\s]\.\d(\s)*\,(\s)*[01\s]\.\d/) and !(params[:af] =~ /^\>\=(\s)*[01\s]\.\d/) and !(params[:af] =~ /^\>(\s)*[01\s]\.\d/) and !(params[:af] =~ /^\<\=(\s)*[01\s]\.\d/) and !(params[:af] =~ /^\<(\s)*[01\s]\.\d/) and !(params[:af] =~ /^\=(\s)*[01\s]\.\d/) and !(params[:af] =~ /^\!\=(\s)*[01\s]\.\d/))
      redirect_to :action => "home"
      flash[:notice] = "Wrong Allele Frequency format !"
      flash[:color]= "invalid"
    else
      #@res = Snp.searchChrPos(params[:chromosome],params[:start_pos],params[:end_pos],params[:chPlatform],params[:chGeneDef],params[:chFunction],params[:af])
      (@res,rlen) = Snp.searchChrPos(params[:chromosome],params[:start_pos],params[:end_pos],params[:chPlatform],params[:chGeneDef],params[:chFunction],params[:af])
      if rlen == 0
        redirect_to :action => "home"
        flash[:notice] = "No variants found in the database for your query parameters !"
        flash[:color]= "invalid"
      end
    end
  end
  
  ## search variants by HGNC gene symbol and Ensembl Gene id
  def search_gene
    ## validation appropriate fields and then query the model
    if ((params[:gene] =~ /\,/) or params[:gene].length > 30)
      redirect_to :action => "home"
      flash[:notice] = "Wrong Gene name format !"
      flash[:color]= "invalid"
elsif(!(params[:af] == "") and !(params[:af] =~ /^\<\>(\s)*[01\s]\.\d(\s)*\,(\s)*[01\s]\.\d/) and !(params[:af] =~ /^\>\=(\s)*[01\s]\.\d/) and !(params[:af] =~ /^\>(\s)*[01\s]\.\d/) and !(params[:af] =~ /^\<\=(\s)*[01\s]\.\d/) and !(params[:af] =~ /^\<(\s)*[01\s]\.\d/) and !(params[:af] =~ /^\=(\s)*[01\s]\.\d/) and !(params[:af] =~ /^\!\=(\s)*[01\s]\.\d/))
      redirect_to :action => "home"
      flash[:notice] = "Wrong Allele Frequency format !"
      flash[:color]= "invalid"
    else
      (@res,rlen) = Snp.searchGene(params[:gene],params[:chPlatform],params[:chGeneDef],params[:chFunction],params[:af])
      if rlen == 0
        redirect_to :action => "home"
        flash[:notice] = "Either not a valid HGNC symbol/Ensembl gene indentifier or no variants in the database for your query gene !"
        flash[:color]= "invalid"
      end
    end
  end  

  ## documentation
  def documentation
  end

  ## about
  def about
  end

  ## contact
  def contact
  end
  
  #private
  
  #def sort_column
    #Snp.column_names.include?(params[:sort]) ? params[:sort] : "AF"
  #  "Allele Freq"
  #end
  
  #def sort_direction
  #  %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  #end
 
end