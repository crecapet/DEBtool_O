function F = fniget_pars_r(U0)
  %% called by iget_pars_r
  
  global v Lb f Hb ab Ub
  
  aUL = lsode('dget_aul', [0; U0; 1e-6], [0, Hb]);
  ab = aUL(2,1); Ub = aUL(2,2); Lb = aUL(2,3);
  F = Ub - f * Lb^3/ v;

