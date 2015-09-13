function dl = dget_lp(l, vH)
  %% l: scalar with scaled length
  %% vH: scalar with scaled maturity
  %% dl: scalar with d/dv_H l
  %% called by get_lp, get_lj
  
  global f_get g k li lT

  f = f_get;
  
  dl = (g/ 3) * (li - l - lT)/ (g + f);           % d/dt l
  dvH = l^2 * (g * li + f * l)/ (g + f) - k * vH; % d/dt vH
  dl = dl/ dvH;                                   % dl/ dvH
  