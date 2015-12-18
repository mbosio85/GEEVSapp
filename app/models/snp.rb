class Snp

  def self
    con = Mysql.connect('www.ediva.crg.eu', 'geevsUser', 'geevspublic', 'GEEVS')
    return con
  end
  
  def self.searchChrPos(chromosome, start_pos, end_pos, platform, genedef, function, varfunction, af,vtype,subgroup)
    
    qry = ""
    afreq = ""
    mainvartypetable = ""
    mainvartypegendeftable = ""
    genetablevarid = ""
    subgrptable = ""

    ## clean gene def
    if genedef == "UCSC/Known"
      genedef = "UCSC"
    end
    ## clean allele frequency
    if (af =~ /^\<\>/)
      operators, values = af.split(/>/)
      val1,val2 = values.split(/,/)
      af = "between "+val1+ " and "+val2
    end
    ## clean function
    #if varfunction != "All"
    #  varfunction = varfunction+" SNV"
    #end

    ## clean for platform 
    if (platform == 'Solid')
      afreq = "S.AF_solid"        
    else
      afreq = "S.AF"
    end

    ## decide on table name based on var type
    if (vtype == "SNP")
      mainvartypetable = "Table_SNP"
      mainvartypegendeftable = "Table_SNP_Annotation_"+genedef
      genetablevarid = "snp_id"
      subgrptable = "Table_SNP_"+subgroup
    else
      mainvartypetable = "Table_INDEL"
      mainvartypegendeftable = "Table_INDEL_Annotation_"+genedef
      genetablevarid = "indel_id"
      subgrptable = "Table_INDEL_"+subgroup
    end

    
    if (subgroup == "All")
      if (function == "All" && varfunction == "All")
        qry = "select S.*,R.* from "+mainvartypetable+" as S inner join "+mainvartypegendeftable+" as R on S.ID = R."+genetablevarid+" WHERE S.chromosome = '"+chromosome+"' 
        AND S.position BETWEEN "+start_pos+" AND "+end_pos+ " AND S."+platform+ " is not NULL AND "+afreq+" "+af+ " limit 5000";
      elsif(function == "All" && varfunction != "All")
        qry = "select S.*,R.* from "+mainvartypetable+" as S inner join "+mainvartypegendeftable+" as R on S.ID = R."+genetablevarid+" WHERE S.chromosome = '"+chromosome+"' 
        AND S.position BETWEEN "+start_pos+" AND "+end_pos+ " AND S."+platform+ " is not NULL AND R.exonic_function = '"+varfunction+"' AND "+afreq+" "+af+ " limit 5000";
      elsif(function != "All" && varfunction == "All")
        qry = "select S.*,R.* from "+mainvartypetable+" as S inner join "+mainvartypegendeftable+" as R on S.ID = R."+genetablevarid+" WHERE S.chromosome = '"+chromosome+"' 
        AND S.position BETWEEN "+start_pos+" AND "+end_pos+ " AND S."+platform+ " is not NULL AND R.function_snp = '"+function+ "' AND "+afreq+" "+af+ " limit 5000";
      else
        qry = "select S.*,R.* from "+mainvartypetable+" as S inner join "+mainvartypegendeftable+" as R on S.ID = R."+genetablevarid+" WHERE S.chromosome = '"+chromosome+"' 
        AND S.position BETWEEN "+start_pos+" AND "+end_pos+ " AND S."+platform+ " is not NULL AND R.function_snp = '"+function+ "' AND R.exonic_function = '"+varfunction+"' AND "+afreq+" "+af+ " limit 5000";
      end
    else
      if (function == "All" && varfunction == "All")
        qry = "select S.*,R.*,G.* from "+mainvartypetable+" as S inner join "+mainvartypegendeftable+" as R inner join "+subgrptable+" as G on S.ID = R."+genetablevarid+" and S.ID = G.ID 
        WHERE S.chromosome = '"+chromosome+"' AND S.position BETWEEN "+start_pos+" AND "+end_pos+ " AND S."+platform+ " is not NULL AND "+afreq+" "+af+ " limit 5000";
      elsif(function == "All" && varfunction != "All")
        qry = "select S.*,R.*,G.* from "+mainvartypetable+" as S inner join "+mainvartypegendeftable+" as R inner join "+subgrptable+" as G on S.ID = R."+genetablevarid+" and S.ID = G.ID 
        WHERE S.chromosome = '"+chromosome+"' AND S.position BETWEEN "+start_pos+" AND "+end_pos+ " AND S."+platform+ " is not NULL AND R.exonic_function = '"+varfunction+"' AND "+afreq+" "+af+ " limit 5000";
      elsif(function != "All" && varfunction == "All")
        qry = "select S.*,R.*,G.* from "+mainvartypetable+" as S inner join "+mainvartypegendeftable+" as R inner join "+subgrptable+" as G on S.ID = R."+genetablevarid+" and S.ID = G.ID 
        WHERE S.chromosome = '"+chromosome+"' AND S.position BETWEEN "+start_pos+" AND "+end_pos+ " AND S."+platform+ " is not NULL AND R.function_snp = '"+function+ "' AND "+afreq+" "+af+ " limit 5000";
      else
        qry = "select S.*,R.*,G.* from "+mainvartypetable+" as S inner join "+mainvartypegendeftable+" as R inner join "+subgrptable+" as G on S.ID = R."+genetablevarid+" and S.ID = G.ID 
        WHERE S.chromosome = '"+chromosome+"' AND S.position BETWEEN "+start_pos+" AND "+end_pos+ " AND S."+platform+ " is not NULL AND R.function_snp = '"+function+ "' AND R.exonic_function = '"+varfunction+"' AND "+afreq+" "+af+ " limit 5000";
      end
    end
    
        
    #qry1 = "SELECT * FROM Table_SNP WHERE chromosome = '"+chromosome+"' AND position = "+start_pos+ " AND "+platform+" is not NULL"   
    #qry2 = "SELECT * FROM Table_SNP WHERE chromosome = '"+chromosome+"' AND position >= "+start_pos+ " AND "+platform+" is not NULL"
    #qry3 = "SELECT * FROM Table_SNP WHERE chromosome = '"+chromosome+"' AND position <= "+end_pos+ " AND "+platform+" is not NULL"
    #qry4 = "SELECT * FROM Table_SNP WHERE chromosome = '"+chromosome+"' AND "+platform+" is not NULL"
    #qry5 = "SELECT * FROM Table_SNP WHERE chromosome = '"+chromosome+"' AND position BETWEEN "+start_pos+" AND "+end_pos+ " AND "+platform+" is not NULL"
    
    ## form query
    #qry = "select S.*,R.* from Table_SNP as S inner join Table_SNP_Annotation_"+genedef+" as R on S.ID = R.snp_id WHERE S.chromosome = '"+chromosome+"' 
    #AND S.position BETWEEN "+start_pos+" AND "+end_pos+ " AND S."+platform+ " is not NULL AND R.exonic_function = '"+function+ "' AND S.AF "+af+ " limit 5000";
    ## create model object and query    
    cc = Snp.new.self
    if start_pos == end_pos && start_pos!="" && end_pos !=""
      #res = Snp.find_all_by_chromosome_and_position(chromosome,pos)
      res = cc.query(qry)
    end
    #else
    if  start_pos != end_pos && start_pos!="" && end_pos ==""
      #cc = Snp.new.self
      res = cc.query(qry)
    end    #res = Snp.find(:all, :conditions => ['chromosome = ? AND position >= ?',chromosome,start_pos])
    
    if start_pos != end_pos && start_pos =="" && end_pos !=""
      #cc = Snp.new.self
      res = cc.query(qry)
    end    #res = Snp.find(:all, :conditions => ['chromosome = ? AND position <= ?',chromosome,end_pos])
    
    if start_pos == end_pos && start_pos=="" && end_pos ==""
      #cc = Snp.new.self
      res = cc.query(qry)
    end    #res = Snp.find_all_by_chromosome(chromosome)
    
    if start_pos != end_pos && start_pos!="" && end_pos !=""
      #cc = Snp.new.self
      res = cc.query(qry) 
        #res = Snp.find(:all, :conditions => ['chromosome = ? AND position >= ? AND position <= ?',chromosome,start_pos,end_pos])
    end# end     
    
    ## close connection
    cc.close
    
    return res,res.num_rows
  end
    
  def self.searchGene(gene, platform, genedef, function, varfunction, af,vtype,subgroup)
    
    qry = ""
    afreq = ""
    mainvartypetable = ""
    mainvartypegendeftable = ""
    genetablevarid = ""
    ensmaptoall = ""
    subgrptable = ""
    
    ## clean gene def
    if (genedef == "UCSC/Known")
      genedef = "UCSC"
    end
    ## clean allele frequency
    if (af and af =~ /^\<\>/)
      operators, values = af.split(/>/)
      val1,val2 = values.split(/,/)
      af = "between "+val1+ " and "+val2
    end
    ## clean for platform 
    if (platform == 'Solid')
      afreq = "S.AF_solid"        
    else
      afreq = "S.AF"
    end

    ## decide on table name based on var type
    if (vtype == "SNP")
      mainvartypetable = "Table_SNP"
      mainvartypegendeftable = "Table_SNP_Annotation_"+genedef
      genetablevarid = "snp_id"
      ensmaptoall = "Table_SNP_Annotation_Ensembl"
      subgrptable = "Table_SNP_"+subgroup
    else
      mainvartypetable = "Table_INDEL"
      mainvartypegendeftable = "Table_INDEL_Annotation_"+genedef
      genetablevarid = "indel_id"
      ensmaptoall = "Table_INDEL_Annotation_Ensembl"
      subgrptable = "Table_INDEL_"+subgroup
    end

    ## clean function
    #if varfunction != "All"
    #  varfunction = varfunction+" SNV"
    #end
    
    ## form query
    if (gene !~ /^ENSG/ and genedef == "Ensembl")
      
      if (subgroup == "All")
        if (function == "All" && varfunction == "All")
        #select S.*,R.snp_id,H.gene_symbol,R.trnascript_name,R.amino_acid_change,R.exonic_function,R.ID 
        #from GEEVS.Table_SNP as S inner join GEEVS.Table_SNP_Annotation_Ensembl as R inner join GEEVS.Table_Gene_symbol_HGNC as H 
        #on S.ID = R.snp_id and R.gene_name = H.ensembl_id;  
                
        qry = "select S.*,R."+genetablevarid+",H.gene_symbol,R.transcript_name,R.amino_acid_change,R.exonic_function,R.ID
        from GEEVS."+mainvartypetable+" as S inner join GEEVS."+ensmaptoall+" as R inner join GEEVS.Table_Gene_symbol_HGNC as H
        on S.ID = R."+genetablevarid+" and R.gene_name = H.ensembl_id WHERE H.gene_symbol = '"+ gene +"' AND S."+ platform + " is not null AND "+afreq+" "+af+ "";
        elsif(function == "All" && varfunction != "All")
        qry = "select S.*,R."+genetablevarid+",H.gene_symbol,R.transcript_name,R.amino_acid_change,R.exonic_function,R.ID
        from GEEVS."+mainvartypetable+" as S inner join GEEVS."+ensmaptoall+" as R inner join GEEVS.Table_Gene_symbol_HGNC as H
        on S.ID = R."+genetablevarid+" and R.gene_name = H.ensembl_id WHERE H.gene_symbol = '"+ gene +"' 
        AND S."+ platform + " is not null AND R.exonic_function = '"+varfunction+"' AND "+afreq+"  "+af+ " limit 5000";
        elsif(function != "All" && varfunction == "All")
        qry = "select S.*,R."+genetablevarid+",H.gene_symbol,R.transcript_name,R.amino_acid_change,R.exonic_function,R.ID
        from GEEVS."+mainvartypetable+" as S inner join GEEVS."+ensmaptoall+" as R inner join GEEVS.Table_Gene_symbol_HGNC as H
        on S.ID = R."+genetablevarid+" and R.gene_name = H.ensembl_id WHERE H.gene_symbol = '"+ gene +"' 
        AND S."+ platform + " is not null AND R.function_snp = '"+ function + "' AND "+afreq+"  "+af+ " limit 5000";
        else
        qry = "select S.*,R."+genetablevarid+",H.gene_symbol,R.transcript_name,R.amino_acid_change,R.exonic_function,R.ID
        from GEEVS."+mainvartypetable+" as S inner join GEEVS."+ensmaptoall+" as R inner join GEEVS.Table_Gene_symbol_HGNC as H
        on S.ID = R."+genetablevarid+" and R.gene_name = H.ensembl_id WHERE H.gene_symbol = '"+ gene +"'
        AND S."+ platform + " is not null AND R.function_snp = '"+ function + "'  AND R.exonic_function = '"+varfunction+"' AND "+afreq+"  "+af+ " limit 5000";    
        end
      else
        if (function == "All" && varfunction == "All")
        qry = "select S.*,R."+genetablevarid+",H.gene_symbol,R.transcript_name,R.amino_acid_change,R.exonic_function,R.ID,G.*
        from GEEVS."+subgrptable+" as S inner join GEEVS."+ensmaptoall+" as R inner join GEEVS.Table_Gene_symbol_HGNC as H inner join GEEVS."+subgrptable+" as G
        on S.ID = R."+genetablevarid+" and S.ID = G.ID and R.gene_name = H.ensembl_id WHERE H.gene_symbol = '"+ gene +"' AND S."+ platform + " is not null AND "+afreq+" "+af+ "";
        elsif(function == "All" && varfunction != "All")
        qry = "select S.*,R."+genetablevarid+",H.gene_symbol,R.transcript_name,R.amino_acid_change,R.exonic_function,R.ID,G.*
        from GEEVS."+mainvartypetable+" as S inner join GEEVS."+ensmaptoall+" as R inner join GEEVS.Table_Gene_symbol_HGNC as H inner join GEEVS."+subgrptable+" as G
        on S.ID = R."+genetablevarid+" and S.ID = G.ID and R.gene_name = H.ensembl_id WHERE H.gene_symbol = '"+ gene +"' 
        AND S."+ platform + " is not null AND R.exonic_function = '"+varfunction+"' AND "+afreq+"  "+af+ " limit 5000";
        elsif(function != "All" && varfunction == "All")
        qry = "select S.*,R."+genetablevarid+",H.gene_symbol,R.transcript_name,R.amino_acid_change,R.exonic_function,R.ID,G.*
        from GEEVS."+mainvartypetable+" as S inner join GEEVS."+ensmaptoall+" as R inner join GEEVS.Table_Gene_symbol_HGNC as H inner join GEEVS."+subgrptable+" as G
        on S.ID = R."+genetablevarid+" and S.ID = G.ID and R.gene_name = H.ensembl_id WHERE H.gene_symbol = '"+ gene +"' 
        AND S."+ platform + " is not null AND R.function_snp = '"+ function + "' AND "+afreq+"  "+af+ " limit 5000";
        else
        qry = "select S.*,R."+genetablevarid+",H.gene_symbol,R.transcript_name,R.amino_acid_change,R.exonic_function,R.ID,G.*
        from GEEVS."+mainvartypetable+" as S inner join GEEVS."+ensmaptoall+" as R inner join GEEVS.Table_Gene_symbol_HGNC as H inner join GEEVS."+subgrptable+" as G
        on S.ID = R."+genetablevarid+" and S.ID = G.ID and R.gene_name = H.ensembl_id WHERE H.gene_symbol = '"+ gene +"'
        AND S."+ platform + " is not null AND R.function_snp = '"+ function + "'  AND R.exonic_function = '"+varfunction+"' AND "+afreq+"  "+af+ " limit 5000";            
        end
      end  
            
    else
      if (subgroup == "All")
        if (function == "All" && varfunction == "All")
        qry = "select S.*,R.* from "+mainvartypetable+" as S inner join "+mainvartypegendeftable+" as R on S.ID = R."+genetablevarid+" WHERE R.gene_name = '"+ gene +"' 
        AND S."+ platform + " is not null AND "+afreq+" "+af+ "";
        elsif(function == "All" && varfunction != "All")
        qry = "select S.*,R.* from "+mainvartypetable+" as S inner join "+mainvartypegendeftable+" as R on S.ID = R."+genetablevarid+" WHERE R.gene_name = '"+ gene +"' 
        AND S."+ platform + " is not null AND R.exonic_function = '"+varfunction+"' AND "+afreq+"  "+af+ " limit 5000";
        elsif(function != "All" && varfunction == "All")
        qry = "select S.*,R.* from "+mainvartypetable+" as S inner join "+mainvartypegendeftable+" as R on S.ID = R."+genetablevarid+" WHERE R.gene_name = '"+ gene +"' 
        AND S."+ platform + " is not null AND R.function_snp = '"+ function + "' AND "+afreq+"  "+af+ " limit 5000";
        else
        qry = "select S.*,R.* from "+mainvartypetable+" as S inner join "+mainvartypegendeftable+" as R on S.ID = R."+genetablevarid+" WHERE R.gene_name = '"+ gene +"' 
        AND S."+ platform + " is not null AND R.function_snp = '"+ function + "'  AND R.exonic_function = '"+varfunction+"' AND "+afreq+"  "+af+ " limit 5000";    
        end         
      else
        if (function == "All" && varfunction == "All")
        qry = "select S.*,R.*,G.* from "+mainvartypetable+" as S inner join "+mainvartypegendeftable+" as R inner join "+subgrptable+" as G on S.ID = R."+genetablevarid+" and S.ID = G.ID 
        WHERE R.gene_name = '"+ gene +"' AND S."+ platform + " is not null AND "+afreq+" "+af+ "";
        elsif(function == "All" && varfunction != "All")
        qry = "select S.*,R.*,G.* from "+mainvartypetable+" as S inner join "+mainvartypegendeftable+" as R inner join "+subgrptable+" as G on S.ID = R."+genetablevarid+" and S.ID = G.ID 
        WHERE R.gene_name = '"+ gene +"' AND S."+ platform + " is not null AND R.exonic_function = '"+varfunction+"' AND "+afreq+"  "+af+ " limit 5000";
        elsif(function != "All" && varfunction == "All")
        qry = "select S.*,R.*,G.* from "+mainvartypetable+" as S inner join "+mainvartypegendeftable+" as R inner join "+subgrptable+" as G on S.ID = R."+genetablevarid+" and S.ID = G.ID 
        WHERE R.gene_name = '"+ gene +"' AND S."+ platform + " is not null AND R.function_snp = '"+ function + "' AND "+afreq+"  "+af+ " limit 5000";
        else
        qry = "select S.*,R.*,G.* from "+mainvartypetable+" as S inner join "+mainvartypegendeftable+" as R inner join "+subgrptable+" as G on S.ID = R."+genetablevarid+" and S.ID = G.ID 
        WHERE R.gene_name = '"+ gene +"' AND S."+ platform + " is not null AND R.function_snp = '"+ function + "'  AND R.exonic_function = '"+varfunction+"' AND "+afreq+"  "+af+ " limit 5000";    
        end         
      end
    end
        
    ## form query
    #qry = "select S.*,R.* from Table_SNP as S inner join Table_SNP_Annotation_"+genedef+" as R on S.ID = R.snp_id WHERE R.gene_name = '"+ gene +"' 
    #AND S."+ platform + " is not NULL AND R.exonic_function = '"+ function + "' AND S.AF "+af+ " limit 5000";   
    ## create model object and query
    cc = Snp.new.self
    res = cc.query(qry)

    ## close connection
    cc.close
    return res,res.num_rows
  end  
 
 
end