function p = pfeed (jX,jA)
  %% p = pfeed (jX,jA)
  %% created 2002/06/04 by Bas Kooijman
  %% calculates expected feeding from arrival flux
  %% jX: arrival rates of substrate
  %% jA: assimilated substrate flux
  %% p: least squares parameter vector


  p = nrregr('ifeed', [max(jA), 1.5, 10]', [jX,jA]);
  
    
  
