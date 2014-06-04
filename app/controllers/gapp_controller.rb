class GappController < ApplicationController

  before_filter :authenticate_user, :only => [:home, :search_chr_pos, :search_gene, :search, :submitdata, :documentation, :about, :contact, :downloads]


  ## home function
  def home
    @platform = ['Illumina','Solid']
    @genedefinition = [ 'Refseq','Ensembl','UCSC/Known']
    @exonicFunction =[ 'All','Exonic','Splicing','Intronic','UTR3','UTR5','Downstream','Upstream','Intergenic','ncRNA_exonic','ncRNA_splicing','ncRNA_intronic','ncRNA_UTR3','ncRNA_UTR5']
    @variantFunction = ['All','Nonsynonymous SNV','Synonymous SNV','Stopgain SNV','Stoploss SNV','Frameshift insertion','Frameshift deletion','Frameshift substitution','Nonframeshift insertion','Nonframeshift deletion','Nonframeshift substitution']    
    @vartype = ['SNP','INDEL']
    @subgrp = ['All','spanish']
  end

  ## search variants by chr and pos
  def search_chr_pos
    @chr = ['1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','X','Y','MT']
    @platform = ['Illumina','Solid']
    @genedefinition = [ 'Refseq','Ensembl','UCSC/Known']
    @exonicFunction =[ 'All','Exonic','Splicing','Intronic','UTR3','UTR5','Downstream','Upstream','Intergenic','ncRNA_exonic','ncRNA_splicing','ncRNA_intronic','ncRNA_UTR3','ncRNA_UTR5']
    @variantFunction = ['All','Nonsynonymous SNV','Synonymous SNV','Stopgain SNV','Stoploss SNV','Frameshift insertion','Frameshift deletion','Frameshift substitution','Nonframeshift insertion','Nonframeshift deletion','Nonframeshift substitution']    
    @vartype = ['SNP','INDEL']
    @subgrp = ['All','spanish']
  end
  
  def search_chr_pos_show
    @chr = ['1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','X','Y','MT']
    @platform = ['Illumina','Solid']
    @genedefinition = [ 'Refseq','Ensembl','UCSC/Known']
    @exonicFunction =[ 'All','Exonic','Splicing','Intronic','UTR3','UTR5','Downstream','Upstream','Intergenic','ncRNA_exonic','ncRNA_splicing','ncRNA_intronic','ncRNA_UTR3','ncRNA_UTR5']
    @variantFunction = ['All','Nonsynonymous SNV','Synonymous SNV','Stopgain SNV','Stoploss SNV','Frameshift insertion','Frameshift deletion','Frameshift substitution','Nonframeshift insertion','Nonframeshift deletion','Nonframeshift substitution']    
    @vartype = ['SNP','INDEL']
    @subgrp = ['All','spanish']
     
    
    ## validation appropriate fields and then query the model
    if (params[:chromosome] == "")
        #redirect_to :action => "search_chr_pos"
        @res = []
        @searchPanelChr = params[:chromosome] 
        @searchPanelStartPos = params[:start_pos]
        @searchPanelEndPos = params[:end_pos]
        @searchPanelAF = params[:af]
        @searchPanelPlatform = params[:chPlatform]
        @searchPanelGeneDef = params[:chGeneDef]
        @searchPanelFunction = params[:chFunction]
        @seerchPanelVarFunction = params[:varfunction]
        @searchPanelVartype = params[:chvartype]
        @seerchPanelSubgroup = params[:subgroup]

        flash[:notice] = "You must select a Chromosome !"
        flash[:color]= "invalid"
    elsif (!(params[:start_pos] =~ /\d/) or !(params[:end_pos] =~ /\d/) or params[:end_pos].length > 11 or params[:start_pos].length > 11 or (params[:end_pos] < params[:start_pos]))
      #redirect_to :action => "search_chr_pos"
        @res = []
        @searchPanelChr = params[:chromosome] 
        @searchPanelStartPos = params[:start_pos]
        @searchPanelEndPos = params[:end_pos]
        @searchPanelAF = params[:af]
        @searchPanelPlatform = params[:chPlatform]
        @searchPanelGeneDef = params[:chGeneDef]
        @searchPanelFunction = params[:chFunction]
        @seerchPanelVarFunction = params[:varfunction]
        @searchPanelVartype = params[:chvartype]
        @seerchPanelSubgroup = params[:subgroup]


        flash[:notice] = "Wrong Position Values !"
        flash[:color]= "invalid"
    elsif(!(params[:af] == "") and !(params[:af] =~ /^\<\>(\s)*[01\s]\.\d(\s)*\,(\s)*[01\s]\.\d/) and !(params[:af] =~ /^\>\=(\s)*[01\s]\.\d/) and !(params[:af] =~ /^\>(\s)*[01\s]\.\d/) and !(params[:af] =~ /^\<\=(\s)*[01\s]\.\d/) and !(params[:af] =~ /^\<(\s)*[01\s]\.\d/) and !(params[:af] =~ /^\=(\s)*[01\s]\.\d/) and !(params[:af] =~ /^\!\=(\s)*[01\s]\.\d/))
      #redirect_to :action => "search_chr_pos"
        @res = []
        @searchPanelChr = params[:chromosome] 
        @searchPanelStartPos = params[:start_pos]
        @searchPanelEndPos = params[:end_pos]
        @searchPanelAF = params[:af]
        @searchPanelPlatform = params[:chPlatform]
        @searchPanelGeneDef = params[:chGeneDef]
        @searchPanelFunction = params[:chFunction]
        @seerchPanelVarFunction = params[:varfunction]
        @searchPanelVartype = params[:chvartype]
        @seerchPanelSubgroup = params[:subgroup]


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
      @searchPanelVartype = params[:chvartype]
      @seerchPanelSubgroup = params[:subgroup]

      (@res,rlen) = Snp.searchChrPos(params[:chromosome],params[:start_pos],params[:end_pos],params[:chPlatform],params[:chGeneDef],params[:chFunction],params[:varfunction],params[:af],params[:chvartype],params[:subgroup])
      if rlen == 0
        #redirect_to :action => "search_chr_pos"
        flash[:notice] = "No variants in the database for your query search term and filters! Try different Chromosome, Positions and Filters !!"
        flash[:color]= "invalid"
      end
    end
  end
  
  
  ## search variants by HGNC gene symbol and Ensembl Gene id
  def search_gene
    @platform = ['Illumina','Solid']
    @genedefinition = [ 'Refseq','Ensembl','UCSC/Known']
    @exonicFunction =[ 'All','Exonic','Splicing','Intronic','UTR3','UTR5','Downstream','Upstream','Intergenic','ncRNA_exonic','ncRNA_splicing','ncRNA_intronic','ncRNA_UTR3','ncRNA_UTR5']
    @variantFunction = ['All','Nonsynonymous SNV','Synonymous SNV','Stopgain SNV','Stoploss SNV','Frameshift insertion','Frameshift deletion','Frameshift substitution','Nonframeshift insertion','Nonframeshift deletion','Nonframeshift substitution']    
    @vartype = ['SNP','INDEL']
    @subgrp = ['All','spanish']  
  end
  
  def search_gene_show
    @platform = ['Illumina','Solid']
    @genedefinition = [ 'Refseq','Ensembl','UCSC/Known']
    @exonicFunction =[ 'All','Exonic','Splicing','Intronic','UTR3','UTR5','Downstream','Upstream','Intergenic','ncRNA_exonic','ncRNA_splicing','ncRNA_intronic','ncRNA_UTR3','ncRNA_UTR5']
    @variantFunction = ['All','Nonsynonymous SNV','Synonymous SNV','Stopgain SNV','Stoploss SNV','Frameshift insertion','Frameshift deletion','Frameshift substitution','Nonframeshift insertion','Nonframeshift deletion','Nonframeshift substitution']    
    @vartype = ['SNP','INDEL']
    @subgrp = ['All','spanish']  
    
    ## validate search gene term
    if (params[:gene] == "")
        redirect_to :action => "search_gene"
        flash[:notice] = "Your search term can't be empty !"
        flash[:color]= "invalid"
    else
    ## validation appropriate fields and then query the model
    if ((params[:gene] =~ /\,/) or params[:gene].length > 50)
      #redirect_to :action => "search_gene"
      @res = []
      @searchPanelGene = params[:gene]
      @searchPanelAF = params[:af]
      @searchPanelPlatform = params[:chPlatform]
      @searchPanelGeneDef = params[:chGeneDef]
      @searchPanelFunction = params[:chFunction]
      @seerchPanelVarFunction = params[:varfunction]
      @searchPanelVartype = params[:chvartype]
      @seerchPanelSubgroup =params[:subgroup]
      
      flash[:notice] = "Wrong Gene name format !"
      flash[:color]= "invalid"
    elsif(params[:gene] =~ /^ENSG/ and params[:chGeneDef] != "Ensembl")
      #redirect_to :action => "search_gene"
      @res = []
      @searchPanelGene = params[:gene]
      @searchPanelAF = params[:af]
      @searchPanelPlatform = params[:chPlatform]
      @searchPanelGeneDef = params[:chGeneDef]
      @searchPanelFunction = params[:chFunction]
      @seerchPanelVarFunction = params[:varfunction]
      @searchPanelVartype = params[:chvartype]
      @seerchPanelSubgroup =params[:subgroup]

      flash[:notice] = "Please select \"Ensembl\" in Gene Definition field !"
      flash[:color]= "invalid"        
    elsif(!(params[:af] == "") and !(params[:af] =~ /^\<\>(\s)*[01\s]\.\d(\s)*\,(\s)*[01\s]\.\d/) and !(params[:af] =~ /^\>\=(\s)*[01\s]\.\d/) and !(params[:af] =~ /^\>(\s)*[01\s]\.\d/) and !(params[:af] =~ /^\<\=(\s)*[01\s]\.\d/) and !(params[:af] =~ /^\<(\s)*[01\s]\.\d/) and !(params[:af] =~ /^\=(\s)*[01\s]\.\d/) and !(params[:af] =~ /^\!\=(\s)*[01\s]\.\d/))
      #redirect_to :action => "search_gene"
      @res = []
      @searchPanelGene = params[:gene]
      @searchPanelAF = params[:af]
      @searchPanelPlatform = params[:chPlatform]
      @searchPanelGeneDef = params[:chGeneDef]
      @searchPanelFunction = params[:chFunction]
      @seerchPanelVarFunction = params[:varfunction]
      @searchPanelVartype = params[:chvartype]
      @seerchPanelSubgroup =params[:subgroup]      

      flash[:notice] = "Wrong Allele Frequency format !"
      flash[:color]= "invalid"
    else
      @searchPanelGene = params[:gene]
      @searchPanelAF = params[:af]
      @searchPanelPlatform = params[:chPlatform]
      @searchPanelGeneDef = params[:chGeneDef]
      @searchPanelFunction = params[:chFunction]
      @seerchPanelVarFunction = params[:varfunction]
      @searchPanelVartype = params[:chvartype]
      @seerchPanelSubgroup =params[:subgroup]
      
      (@res,rlen) = Snp.searchGene(params[:gene],params[:chPlatform],params[:chGeneDef],params[:chFunction],params[:varfunction],params[:af],params[:chvartype],params[:subgroup])
      if rlen == 0
        #redirect_to :action => "search_gene"
        flash[:notice] = "Either not a valid HGNC symbol/Ensembl gene indentifier or no variants in the database for your search term and filters ! Try different Genes and filters !!"
        flash[:color]= "invalid"
      end
    end
   end 
  end  

  ## combined search function
  def search
    @platform = ['Illumina','Solid']
    @genedefinition = [ 'Refseq','Ensembl','UCSC/Known']
    @exonicFunction =[ 'All','Exonic','Splicing','Intronic','UTR3','UTR5','Downstream','Upstream','Intergenic','ncRNA_exonic','ncRNA_splicing','ncRNA_intronic','ncRNA_UTR3','ncRNA_UTR5']
    @variantFunction = ['All','Nonsynonymous SNV','Synonymous SNV','Stopgain SNV','Stoploss SNV','Frameshift insertion','Frameshift deletion','Frameshift substitution','Nonframeshift insertion','Nonframeshift deletion','Nonframeshift substitution']
    @vartype = ['SNP','INDEL']
    @subgrp = ['All','spanish']

    ## validate search term
    if (params[:searchTerm] == "")
        redirect_to :action => "home"
        flash[:notice] = "Your search term can't be empty !"
        flash[:color]= "invalid"      
    else
      if (params[:searchTerm] =~ /\:/)
        ## checking for chr:pos1-pos2 format
        if (params[:searchTerm] !~ /^[cC]hr(\d)+\:(\d)+\-(\d)+/ and params[:searchTerm] !~ /^[cC]hr[XY]\:(\d)+\-(\d)+/) 
        #redirect_to :action => "home"
        @res = []
        @searchPanelTerm = params[:searchTerm]
        @searchPanelAF = params[:af]
        @searchPanelPlatform = params[:chPlatform]
        @searchPanelGeneDef = params[:chGeneDef]
        @searchPanelFunction = params[:chFunction]
        @seerchPanelVarFunction = params[:varfunction]
        @searchPanelVartype = params[:chvartype]
        @seerchPanelSubgroup = params[:subgroup]

        flash[:notice] = "Wrong Chromosome and Position format !"
        flash[:color]= "invalid"
        else
        chrm,poss = params[:searchTerm].split(/\:/)
        startpos,endpos = poss.split(/\-/)
        chrm = chrm[3,chrm.length]
          if (chrm.length > 2 or chrm == "0")
          #redirect_to :action => "home"
          @res = []
          @searchPanelTerm = params[:searchTerm]
          @searchPanelAF = params[:af]
          @searchPanelPlatform = params[:chPlatform]
          @searchPanelGeneDef = params[:chGeneDef]
          @searchPanelFunction = params[:chFunction]
          @seerchPanelVarFunction = params[:varfunction]
          @searchPanelVartype = params[:chvartype]
          @seerchPanelSubgroup = params[:subgroup]
        
          flash[:notice] = "Wrong Chromosome value !"
          flash[:color]= "invalid"
          elsif ((startpos.length > 11) and (endpos.length > 11))
          #redirect_to :action => "home"
          @res = []
          @searchPanelTerm = params[:searchTerm]
          @searchPanelAF = params[:af]
          @searchPanelPlatform = params[:chPlatform]
          @searchPanelGeneDef = params[:chGeneDef]
          @searchPanelFunction = params[:chFunction]
          @seerchPanelVarFunction = params[:varfunction]
          @searchPanelVartype = params[:chvartype]          
          @seerchPanelSubgroup = params[:subgroup] 
          
          flash[:notice] = "Wrong Position values !"
          flash[:color]= "invalid"
          elsif(!(params[:af] == "") and !(params[:af] =~ /^\<\>(\s)*[01\s]\.\d(\s)*\,(\s)*[01\s]\.\d/) and !(params[:af] =~ /^\>\=(\s)*[01\s]\.\d/) and !(params[:af] =~ /^\>(\s)*[01\s]\.\d/) and !(params[:af] =~ /^\<\=(\s)*[01\s]\.\d/) and !(params[:af] =~ /^\<(\s)*[01\s]\.\d/) and !(params[:af] =~ /^\=(\s)*[01\s]\.\d/) and !(params[:af] =~ /^\!\=(\s)*[01\s]\.\d/))
          #redirect_to :action => "home"
          @res = []
          @searchPanelTerm = params[:searchTerm]
          @searchPanelAF = params[:af]
          @searchPanelPlatform = params[:chPlatform]
          @searchPanelGeneDef = params[:chGeneDef]
          @searchPanelFunction = params[:chFunction]
          @seerchPanelVarFunction = params[:varfunction]
          @searchPanelVartype = params[:chvartype]
          @seerchPanelSubgroup = params[:subgroup]

          flash[:notice] = "Wrong Allele Frequency format !"
          flash[:color]= "invalid"     
          else
          @searchPanelTerm = params[:searchTerm]
          @searchPanelAF = params[:af]
          @searchPanelPlatform = params[:chPlatform]
          @searchPanelGeneDef = params[:chGeneDef]
          @searchPanelFunction = params[:chFunction]
          @seerchPanelVarFunction = params[:varfunction]
          @searchPanelVartype = params[:chvartype]
          @seerchPanelSubgroup = params[:subgroup] 

          (@res,rlen) = Snp.searchChrPos(chrm,startpos,endpos,params[:chPlatform],params[:chGeneDef],params[:chFunction],params[:varfunction],params[:af],params[:chvartype],params[:subgroup])
          if rlen == 0
            #redirect_to :action => "home"
            flash[:notice] = "No variants in the database for your query search term and filters! Try different Chromosome, Positions and Filters !!"
            flash[:color]= "invalid"
          end
          end   
         end
     else
    ## checking for gene name format
       if (params[:searchTerm] =~ /\,/ and params[:searchTerm].length > 50)
        #redirect_to :action => "home"
        @res = []
        @searchPanelTerm = params[:searchTerm]
        @searchPanelAF = params[:af]
        @searchPanelPlatform = params[:chPlatform]
        @searchPanelGeneDef = params[:chGeneDef]
        @searchPanelFunction = params[:chFunction]
        @seerchPanelVarFunction = params[:varfunction]
        @searchPanelVartype = params[:chvartype]
        @seerchPanelSubgroup = params[:subgroup]
        
        flash[:notice] = "Wrong Gene name format !"
        flash[:color]= "invalid"
      elsif(params[:searchTerm] =~ /^ENSG/ and params[:chGeneDef] != "Ensembl")
        #redirect_to :action => "home"
        @res = []
        @searchPanelTerm = params[:searchTerm]
        @searchPanelAF = params[:af]
        @searchPanelPlatform = params[:chPlatform]
        @searchPanelGeneDef = params[:chGeneDef]
        @searchPanelFunction = params[:chFunction]
        @seerchPanelVarFunction = params[:varfunction]
        @searchPanelVartype = params[:chvartype]
        @seerchPanelSubgroup = params[:subgroup]
        
        flash[:notice] = "Please select \"Ensembl\" in Gene Definition field !"
        flash[:color]= "invalid"        
      elsif(!(params[:af] == "") and !(params[:af] =~ /^\<\>(\s)*[01\s]\.\d(\s)*\,(\s)*[01\s]\.\d/) and !(params[:af] =~ /^\>\=(\s)*[01\s]\.\d/) and !(params[:af] =~ /^\>(\s)*[01\s]\.\d/) and !(params[:af] =~ /^\<\=(\s)*[01\s]\.\d/) and !(params[:af] =~ /^\<(\s)*[01\s]\.\d/) and !(params[:af] =~ /^\=(\s)*[01\s]\.\d/) and !(params[:af] =~ /^\!\=(\s)*[01\s]\.\d/))
        #redirect_to :action => "home"
        @res = []
        @searchPanelTerm = params[:searchTerm]
        @searchPanelAF = params[:af]
        @searchPanelPlatform = params[:chPlatform]
        @searchPanelGeneDef = params[:chGeneDef]
        @searchPanelFunction = params[:chFunction]
        @seerchPanelVarFunction = params[:varfunction]
        @searchPanelVartype = params[:chvartype]
        @seerchPanelSubgroup = params[:subgroup]
        
        flash[:notice] = "Wrong Allele Frequency format !"
        flash[:color]= "invalid"
      else
        @searchPanelTerm = params[:searchTerm]
        @searchPanelAF = params[:af]
        @searchPanelPlatform = params[:chPlatform]
        @searchPanelGeneDef = params[:chGeneDef]
        @searchPanelFunction = params[:chFunction]
        @seerchPanelVarFunction = params[:varfunction]
        @searchPanelVartype = params[:chvartype]
        @seerchPanelSubgroup = params[:subgroup]
        
        (@res,rlen) = Snp.searchGene(params[:searchTerm],params[:chPlatform],params[:chGeneDef],params[:chFunction],params[:varfunction],params[:af],params[:chvartype],params[:subgroup])
        if rlen == 0
          #redirect_to :action => "search"
          flash[:notice] = "Either not a valid HGNC symbol/Ensembl gene indentifier or no variants in the database for your search term and filters ! Try different Genes and filters !!"
          flash[:color]= "invalid"
        end
      end 
      end
   end
  
  end

  ## Data submit
  def submitdata
    @platform = ['Illumina','Solid']
  end
  
  ## Data submission handler
  def handleSubmittedData
    if (params[:checkTermsAndCondition] == "confirm")
      if (params[:platform] == "" or params[:datauser] == "" or params[:email] == "" or params[:institute] == "" or params[:instituteUrl] == "")
        redirect_to :action => "submitdata"
        flash[:notice] = "You must complete all fields !"
        flash[:color]= "invalid"
        return
      else
        @msg = Datafile.handleUserDataSubmission(params[:platform],params[:datauser],params[:email],params[:institute],params[:instituteUrl],params[:logo],params[:varinatFile])
        if @msg == "success"
          redirect_to :action => "submitdata"
          flash[:notice] = "Congratulations, you have successfully submitted data to GEEVS ! GEEVS team will contact you soon !!"
          flash[:color]= "valid"
          return
        else
          redirect_to :action => "submitdata"
          flash[:notice] = "Something went wrong ! Contact the GEEVS team !!"
          flash[:color]= "invalid"
          return
        end
      end  
   else
    redirect_to :action => "submitdata"
    flash[:notice] = "You must aggree to the terms and conditions of GEEVS !"
    flash[:color]= "invalid"      
    return
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
  
  ## statistics
  def stat
    
  end
 
  def downloads
    
  end

  def downloadsAction
    fileToDownload = params[:dlfile]
    send_file Rails.root.join('uploads',fileToDownload), :disposition => 'attachment'
  end


end