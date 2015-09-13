function F = fniget_pars_g(U0)
  %% called by iget_pars_g
  
  global v Lb f
  
  aUL = lsode('dget_au',[0; U0], [0, Lb]);
  F = aUL(2,2) - f * Lb^3/ v;
