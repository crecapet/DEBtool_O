function f = find_effect_time (t)
  %% called from fomort2 via fsolve
  %% used to obtain time at which effects start
  
  global cA cB CA0 CB0 kA kB
  A = (1 - exp(- t * kA)) * cA/ max(1e-6,CA0);
  B = (1 - exp(- t * kB)) * cB/ max(1e-6,CB0);
  f = 1 - A - B;
