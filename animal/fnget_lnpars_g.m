function F = fnget_lnpars_g(p)
  %% like fnget_pars_g but with log transformation to avoid negative results
  %% called by get_lnpars, get_pars_g
  %% calls dget_ul
  
  global Lb Lm rB ab g v f
  
  %% unpack variables
  g   = exp(p(1)); % energy investment ratio
  kM  = exp(p(2)); % somatic maintenance rate coefficient
  v   = exp(p(3)); % energy conductance
  U0  = exp(p(4)); % scaled reserve at age 0: M_E^0/{J_EAm}
  
  f1 = Lm - v/ (kM * g);
  
  f2 = rB - kM * g/ (3 * (f + g));
  
  UL = lsode('dget_ul', [U0; 1e-6], [0; ab]);
  f3 = UL(2,1) - f * Lb^3/ v ;
  f4 = UL(2,2) - Lb;

  %% pack output
  F = [f1;f2;f3;f4];
