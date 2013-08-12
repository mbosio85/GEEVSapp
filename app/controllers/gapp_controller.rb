class GappController < ApplicationController

  before_filter :authenticate_user, :only => [:home, :search_chr_pos, :search_gene, :search, :submitdata, :documentation, :about, :contact]


  ## home function
  def home
    @platform = ['Illumina','Solid']
    @genedefinition = [ 'Refseq','Ensembl','UCSC/Known']
    @exonicFunction =[ 'All','Exonic','Splicing','Intronic''UTR3','UTR5','Downstream','Upstream','Intergenic','ncRNA_exoic','ncRNA_splicing','ncRNA_intronic','ncRNA_UTR3','ncRNA_UTR5']
    @variantFunction = ['All','Nonsynonymous','Synonymous','Stopgain','Stoploss']
  end

  ## search variants by chr and pos
  def search_chr_pos
    @chr = ['1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','X','Y','MT']
    @platform = ['Illumina','Solid']
    @genedefinition = [ 'Refseq','Ensembl','UCSC/Known']
    @exonicFunction =[ 'All','Exonic','Splicing','Intronic''UTR3','UTR5','Downstream','Upstream','Intergenic','ncRNA_exoic','ncRNA_splicing','ncRNA_intronic','ncRNA_UTR3','ncRNA_UTR5']
    @variantFunction = ['All','Nonsynonymous','Synonymous','Stopgain','Stoploss']
  end
  
  def search_chr_pos_show
    @chr = ['1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','X','Y','MT']
    @platform = ['Illumina','Solid']
    @genedefinition = [ 'Refseq','Ensembl','UCSC/Known']
    @exonicFunction =[ 'All','Exonic','Splicing','Intronic''UTR3','UTR5','Downstream','Upstream','Intergenic','ncRNA_exoic','ncRNA_splicing','ncRNA_intronic','ncRNA_UTR3','ncRNA_UTR5']
    @variantFunction = ['All','Nonsynonymous','Synonymous','Stopgain','Stoploss']    
    
    
    ## validation appropriate fields and then query the model
    if (params[:chromosome] == "")
      redirect_to :action => "search_chr_pos"
      flash[:notice] = "You must select a Chromosome !"
      flash[:color]= "invalid"
    elsif (!(params[:start_pos] =~ /\d/) or !(params[:end_pos] =~ /\d/) or params[:end_pos].length > 11 or params[:start_pos].length > 11 or (params[:end_pos] < params[:start_pos]))
      redirect_to :action => "search_chr_pos"
      flash[:notice] = "Wrong Position Values !"
      flash[:color]= "invalid"
    elsif(!(params[:af] == "") and !(params[:af] =~ /^\<\>(\s)*[01\s]\.\d(\s)*\,(\s)*[01\s]\.\d/) and !(params[:af] =~ /^\>\=(\s)*[01\s]\.\d/) and !(params[:af] =~ /^\>(\s)*[01\s]\.\d/) and !(params[:af] =~ /^\<\=(\s)*[01\s]\.\d/) and !(params[:af] =~ /^\<(\s)*[01\s]\.\d/) and !(params[:af] =~ /^\=(\s)*[01\s]\.\d/) and !(params[:af] =~ /^\!\=(\s)*[01\s]\.\d/))
      redirect_to :action => "search_chr_pos"
      flash[:notice] = "Wrong Allele Frequency format !"
      flash[:color]= "invalid"
    else
      #@res = Snp.searchChrPos(params[:chromosome],params[:start_pos],params[:end_pos],params[:chPlatform],params[:chGeneDef],params[:chFunction],params[:af])
      @searchPanelChr = params[:chromosome] 
      @searchPanelStartPos = params[:start_pos]
      @searchPanelEndPos = params[:end_pos]
      @searchPanelAF = params[:af]
      @searchPanelPlatform = params[:chPlatform]
      @searchPanelGeneDef = params[:chGeneDef]
      @searchPanelFunction = params[:chFunction]
      @seerchPanelVarFunction = params[:varfunction]

      (@res,rlen) = Snp.searchChrPos(params[:chromosome],params[:start_pos],params[:end_pos],params[:chPlatform],params[:chGeneDef],params[:chFunction],params[:varfunction],params[:af])
      if rlen == 0
        redirect_to :action => "search_chr_pos"
        flash[:notice] = "No variants found in the database for your query parameters !"
        flash[:color]= "invalid"
      end
    end
  end
  
  
  ## search variants by HGNC gene symbol and Ensembl Gene id
  def search_gene
    @platform = ['Illumina','Solid']
    @genedefinition = [ 'Refseq','Ensembl','UCSC/Known']
    @exonicFunction =[ 'All','Exonic','Splicing','Intronic''UTR3','UTR5','Downstream','Upstream','Intergenic','ncRNA_exoic','ncRNA_splicing','ncRNA_intronic','ncRNA_UTR3','ncRNA_UTR5']
    @variantFunction = ['All','Nonsynonymous','Synonymous','Stopgain','Stoploss']    
  end
  
  def search_gene_show
    @platform = ['Illumina','Solid']
    @genedefinition = [ 'Refseq','Ensembl','UCSC/Known']
    @exonicFunction =[ 'All','Exonic','Splicing','Intronic''UTR3','UTR5','Downstream','Upstream','Intergenic','ncRNA_exoic','ncRNA_splicing','ncRNA_intronic','ncRNA_UTR3','ncRNA_UTR5']
    @variantFunction = ['All','Nonsynonymous','Synonymous','Stopgain','Stoploss']
    
    ## validation appropriate fields and then query the model
    if ((params[:gene] =~ /\,/) or params[:gene].length > 50)
      redirect_to :action => "search_gene"
      flash[:notice] = "Wrong Gene name format !"
      flash[:color]= "invalid"
    elsif(params[:gene] =~ /^ENSG/ and params[:chGeneDef] != "Ensembl")
      redirect_to :action => "search_gene"
      flash[:notice] = "Please select \"Ensembl\" in Gene Definition field !"
      flash[:color]= "invalid"        
    elsif(!(params[:af] == "") and !(params[:af] =~ /^\<\>(\s)*[01\s]\.\d(\s)*\,(\s)*[01\s]\.\d/) and !(params[:af] =~ /^\>\=(\s)*[01\s]\.\d/) and !(params[:af] =~ /^\>(\s)*[01\s]\.\d/) and !(params[:af] =~ /^\<\=(\s)*[01\s]\.\d/) and !(params[:af] =~ /^\<(\s)*[01\s]\.\d/) and !(params[:af] =~ /^\=(\s)*[01\s]\.\d/) and !(params[:af] =~ /^\!\=(\s)*[01\s]\.\d/))
      redirect_to :action => "search_gene"
      flash[:notice] = "Wrong Allele Frequency format !"
      flash[:color]= "invalid"
    else
      @searchPanelGene = params[:gene]
      @searchPanelAF = params[:af]
      @searchPanelPlatform = params[:chPlatform]
      @searchPanelGeneDef = params[:chGeneDef]
      @searchPanelFunction = params[:chFunction]
      @seerchPanelVarFunction = params[:varfunction]
      
      (@res,rlen) = Snp.searchGene(params[:gene],params[:chPlatform],params[:chGeneDef],params[:chFunction],params[:varfunction],params[:af])
      if rlen == 0
        redirect_to :action => "search_gene"
        flash[:notice] = "Either not a valid HGNC symbol/Ensembl gene indentifier or no variants in the database for your query gene !"
        flash[:color]= "invalid"
      end
    end
  end  

  ## combined search function
  def search
    @platform = ['Illumina','Solid']
    @genedefinition = [ 'Refseq','Ensembl','UCSC/Known']
    @exonicFunction =[ 'All','Exonic','Splicing','Intronic''UTR3','UTR5','Downstream','Upstream','Intergenic','ncRNA_exoic','ncRNA_splicing','ncRNA_intronic','ncRNA_UTR3','ncRNA_UTR5']
    @variantFunction = ['All','Nonsynonymous','Synonymous','Stopgain','Stoploss']


    ## validate search term
    if (params[:searchTerm] =~ /\:/)
      ## checking for chr:pos1-pos2 format
      if (params[:searchTerm] !~ /^[cC]hr(\d)+\:(\d)+\-(\d)+/ and params[:searchTerm] !~ /^[cC]hr[XY]\:(\d)+\-(\d)+/) 
        redirect_to :action => "home"
        flash[:notice] = "Wrong Chromosome and Position format !"
        flash[:color]= "invalid"
      else
        chrm,poss = params[:searchTerm].split(/\:/)
        startpos,endpos = poss.split(/\-/)
        chrm = chrm[3,chrm.length]
        if (chrm.length > 2 or chrm == "0")
          redirect_to :action => "home"
          flash[:notice] = "Wrong Chromosome value !"
          flash[:color]= "invalid"
        elsif ((startpos.length > 11) and (endpos.length > 11))
          redirect_to :action => "home"
          flash[:notice] = "Wrong Position values !"
          flash[:color]= "invalid"
        elsif(!(params[:af] == "") and !(params[:af] =~ /^\<\>(\s)*[01\s]\.\d(\s)*\,(\s)*[01\s]\.\d/) and !(params[:af] =~ /^\>\=(\s)*[01\s]\.\d/) and !(params[:af] =~ /^\>(\s)*[01\s]\.\d/) and !(params[:af] =~ /^\<\=(\s)*[01\s]\.\d/) and !(params[:af] =~ /^\<(\s)*[01\s]\.\d/) and !(params[:af] =~ /^\=(\s)*[01\s]\.\d/) and !(params[:af] =~ /^\!\=(\s)*[01\s]\.\d/))
          redirect_to :action => "home"
          flash[:notice] = "Wrong Allele Frequency format !"
          flash[:color]= "invalid"     
        else
          @searchPanelTerm = params[:searchTerm]
          @searchPanelAF = params[:af]
          @searchPanelPlatform = params[:chPlatform]
          @searchPanelGeneDef = params[:chGeneDef]
          @searchPanelFunction = params[:chFunction]
          @seerchPanelVarFunction = params[:varfunction]
          (@res,rlen) = Snp.searchChrPos(chrm,startpos,endpos,params[:chPlatform],params[:chGeneDef],params[:chFunction],params[:varfunction],params[:af])
          if rlen == 0
            redirect_to :action => "home"
            flash[:notice] = "No variants in the database for your query search term ! Try different Chromosome and Positions !!"
            flash[:color]= "invalid"
        end
       end   
      end
    else
    ## checking for gene name format
      if (params[:searchTerm] =~ /\,/ and params[:searchTerm].length > 50)
        redirect_to :action => "home"
        flash[:notice] = "Wrong Gene name format !"
        flash[:color]= "invalid"
      elsif(params[:searchTerm] =~ /^ENSG/ and params[:chGeneDef] != "Ensembl")
        redirect_to :action => "home"
        flash[:notice] = "Please select \"Ensembl\" in Gene Definition field !"
        flash[:color]= "invalid"        
      elsif(!(params[:af] == "") and !(params[:af] =~ /^\<\>(\s)*[01\s]\.\d(\s)*\,(\s)*[01\s]\.\d/) and !(params[:af] =~ /^\>\=(\s)*[01\s]\.\d/) and !(params[:af] =~ /^\>(\s)*[01\s]\.\d/) and !(params[:af] =~ /^\<\=(\s)*[01\s]\.\d/) and !(params[:af] =~ /^\<(\s)*[01\s]\.\d/) and !(params[:af] =~ /^\=(\s)*[01\s]\.\d/) and !(params[:af] =~ /^\!\=(\s)*[01\s]\.\d/))
        redirect_to :action => "home"
        flash[:notice] = "Wrong Allele Frequency format !"
        flash[:color]= "invalid"
      else
        @searchPanelTerm = params[:searchTerm]
        @searchPanelAF = params[:af]
        @searchPanelPlatform = params[:chPlatform]
        @searchPanelGeneDef = params[:chGeneDef]
        @searchPanelFunction = params[:chFunction]
        @seerchPanelVarFunction = params[:varfunction]
        (@res,rlen) = Snp.searchGene(params[:searchTerm],params[:chPlatform],params[:chGeneDef],params[:chFunction],params[:varfunction],params[:af])
        if rlen == 0
          redirect_to :action => "home"
          flash[:notice] = "Either not a valid HGNC symbol/Ensembl gene indentifier or no variants in the database for your query gene !"
          flash[:color]= "invalid"
        end
      end 
    end
  
  end

  ## Data submit
  def submitdata
    @platform = ['Illumina','Solid']
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
  
  ## statistics
  def stat
    
  end
 
end