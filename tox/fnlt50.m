function f = fnlt50 (t)
  %% f = fnlt50 (t)
  %% created 2001/12/28 by Bas Kooijman
  %% routine called by shlc50
  %% f = 0 for t = lt50
  
  global c C0 Bk Ke;
  
  t0 = - log(1 - C0/ c)/ Ke;
  f = log(2) + (exp(-Ke * t0) - exp(-Ke * t)) * c * Bk/ Ke - ...
      Bk * (c - C0) * (t - t0);
