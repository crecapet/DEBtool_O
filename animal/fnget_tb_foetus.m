function fn = fnget_tb_foetus(t)
  %% t: scaled age at birth \tau_b = a_b k_M
  %% x: dummy for application of nmregr


  global k g vHb % from get_tb_foetus

  fn = -6 + 6 * k * (1 + t) - 3 * k^2 * t * (2 + t) + k^3 * t^2 * (3 + t);
  fn = (fn + 6 * (1 - k) * exp(- k * t)) * g^3/ 27/ k^4 - vHb;
    