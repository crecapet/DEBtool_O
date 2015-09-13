function f = dget_tb(x)
  %% called by get_tb

  global ab xb

  f = 1/ ((1 - x) * x^(2/ 3) * (ab - beta0(x, xb)));
