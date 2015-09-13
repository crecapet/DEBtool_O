function [aULH U0] = get_aulh_f(par)
  %% [aULH U0] = get_aul_f(par)
  %% similar to get_aul, but for foetus
  %% Bas Kooijman, 2006/09/10
  %% par: 6-vector with parameters
  %% aUL: 4-vector with a_b, U^b, L_b, H^b for foetus
  %%  U^b = M_E^b/{J_EAm}; H^b = M_H/{J_EAm};
  %% U0:  scalar with U^0 = M_E^0/{J_EAm} for foetus

  kap  = par(1);
  v    = par(2);
  kM   = par(3);
  kJ   = par(4);
  g    = par(5);
  Lb   = par(6);

  ab = 3 * Lb/ v;   % age at birth
  Ub = Lb^3/ v;     % scaled reserve at birth M_E^b/{J_EAm}

  aJ = kJ * ab; aM = kM * ab; c = 6 * (1 - exp(-aJ)) * (1 - kM/ kJ);
  c = c + (aJ - 2) * (aM * (aJ - 3) + 3 * aJ) + 2 * aJ * aM;
  Hb = c * v^2 * g * (1 - kap)/ (27 * kJ^3);

  %% scaled reserve required to make an ambryo ME^0/{J_EAm}
  U0 = (1 + (1 - kap) * g * (1 + 0.25 * ab * kM)) * Lb^3/ v;
  
  aULH = [ab, Ub, Lb, Hb]; 
