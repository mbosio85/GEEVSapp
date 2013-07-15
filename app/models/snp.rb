class Snp

  def self
    con = Mysql.connect('www.ediva.crg.eu', 'geevsUser', 'geevspublic', 'GEEVS')
    return con
  end
  
  def self.searchChrPos(chromosome, start_pos, end_pos, platform, genedef, function,af)
    ## clean gene def
    if genedef == "UCSC/Known"
      genedef = "UCSC"
    end
    ## clean exonic function
    if function == "Exonic/Splicing"
      function = "exonic;splicing"
    end
    
    #qry1 = "SELECT * FROM Table_SNP WHERE chromosome = '"+chromosome+"' AND position = "+start_pos+ " AND "+platform+" is not NULL"   
    #qry2 = "SELECT * FROM Table_SNP WHERE chromosome = '"+chromosome+"' AND position >= "+start_pos+ " AND "+platform+" is not NULL"
    #qry3 = "SELECT * FROM Table_SNP WHERE chromosome = '"+chromosome+"' AND position <= "+end_pos+ " AND "+platform+" is not NULL"
    #qry4 = "SELECT * FROM Table_SNP WHERE chromosome = '"+chromosome+"' AND "+platform+" is not NULL"
    #qry5 = "SELECT * FROM Table_SNP WHERE chromosome = '"+chromosome+"' AND position BETWEEN "+start_pos+" AND "+end_pos+ " AND "+platform+" is not NULL"
    
    ## form query
    qry = "select S.*,R.* from Table_SNP as S inner join Table_SNP_Annotation_"+genedef+" as R on S.ID = R.snp_id WHERE S.chromosome = '"+chromosome+"' 
    AND S.position BETWEEN "+start_pos+" AND "+end_pos+ " AND S."+platform+ " is not NULL AND R.exonic_function = '"+function+ "' AND S.AF "+af+ " limit 50000";
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
    
    return res
  end
    
  def self.searchGene(gene, platform, genedef, function, af)
    ## clean gene def
    if (genedef == "UCSC/Known")
      genedef = "UCSC"
    end
    ## clean exonic function
    if (function == "Exonic/Splicing")
      function = "exonic;splicing"
    end
    ## form query
    qry = "select S.*,R.* from Table_SNP as S inner join Table_SNP_Annotation_"+genedef+" as R on S.ID = R.snp_id WHERE R.gene_name = '"+ gene +"' 
    AND S."+ platform + " is not NULL AND R.exonic_function = '"+ function + "' AND S.AF "+af+ " limit 50000";   
    ## create model object and query
    cc = Snp.new.self
    res = cc.query(qry)

    ## close connection
    cc.close
    
    return res
  end  
 
end