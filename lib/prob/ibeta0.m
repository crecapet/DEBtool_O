function f = ibeta0 (t)
  %% f = ibeta0 (t)
  %% Created: 28 aug 2000 by Bas Kooijman
  %% incomplete beta function: B_x(a,0) = \int_0^x t^(a-1) (1-t)^(-1) dt
  %% usage: quad("ibeta0",0,x), after par_ibeta0 = a, and  global par_ibeta
  %% Requires: -
  
  global par_ibeta0 

  f = t^(par_ibeta0 - 1)/(1 - t);
  