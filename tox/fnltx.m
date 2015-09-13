function f = fnltx (t)
  %% f = fnltx (t)
  %% created 2002/06/04 by Bas Kooijman
  %% routine called by shl(100x)
  %% f = 0 for t = lt(100x)
  
  global c C0 Bk Ke X;
  
  t0 = - log(1 - C0/ c)/ Ke;
  f = - log(X) + (exp(-Ke * t0) - exp(-Ke * t)) * c * Bk/ Ke - ...
      Bk * (c - C0) * (t - t0);
