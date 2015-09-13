function dH = dget_h_p(H,t)
  %% dH = dget_h_p(H,t)
  %% H : scaled maturity M_H/ {J_{EAm}}
  %% t : time since birth a - ab
  %% dH: change in scaled maturity at abundant food
  %% called by get_pars, fnget_pars_r
  
  global Lb Lp Lm rB kJ kap G

  L = Lm - (Lm - Lb) * exp(- rB * t); % length at time since birth
  
  dH = (1 - kap) * L^2 * (G/ (G + 1)) * (1 + L/ (G * Lm)) - kJ * H;
