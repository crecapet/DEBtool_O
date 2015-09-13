function f = beta_x (x)
  %% f = beta_x (x)
  %% created 2006/10/28 by Bas Kooijman
  %% called by beta
  
  a = sqrt(3);
  f = a * atan((1 + 2 * x)/ a) - log(x - 1) + log(1 + x + x ^ 2)/ 2 - 3 * x;
