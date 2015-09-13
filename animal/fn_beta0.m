function f = fn_beta0 (t)
  %% f = beta0 (x0,x1)
  %% created 2000/08/16 by Bas Kooijman
  %% special incomplete beta function:
  %%   B_x1(4/3,0) - B_x0(4/3,0) = \int_x0^x1 t^(4/3-1) (1-t)^(-1) dt
  
  f = t^(4/3-1) * (1-t)^(-1);
