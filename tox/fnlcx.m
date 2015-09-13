function f = fnlcx (c)
  %% f = fnlcx (c)
  %% created 2002/06/04 by Bas Kooijman
  %% routine called by shlcx
  %% f = 0 for c = lc(100x)
  global t C0 Bk Ke X;
  
  t0 = - log(1 - C0/ c)/ Ke;
  f = -log(1-X) + c * (exp(-Ke * t0) - exp(-Ke * t)) * Bk/ Ke - ...
      Bk * (c - C0) * (t - t0);
