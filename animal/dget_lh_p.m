function dLH = dget_lh_p(LH)
  %% dLH = dget_lh_p(LH)
  %% LH: 2-vector L : structural length; H : scaled maturity M_H/ {J_{EAm}}
  %% dLH: change in length, scaled maturity at abundant food
  %% called by get_pars, fnget_lnpars_r
  
  global Lm rB g kJ kap

  %% unpack variables
  L = LH(1); H = LH(2);
  
  dL = rB * (Lm - L);
  dH = (1 - kap) * L^2 * (g/ (g + 1)) * (1 + L/ (g * Lm)) - kJ * H;

  dLH = [dL; dH];
