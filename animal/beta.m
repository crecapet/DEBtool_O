function f = beta (x0,x1)
  %% f = beta (x0,x1)
  %% created 2006/10/28 by Bas Kooijman
  %% special incomplete beta function:
  %%   B_x1(4/3,0) - B_x0(4/3,0) = \int_x0^x1 t^(4/3-1) (1-t)^(-1) dt
  
  f = beta_x(x1 ^ (1/ 3)) - beta_x(x0 ^ (1/ 3));
