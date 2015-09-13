function dHL = dget_HL(HL, a)
  % V1-morphic juvenile I, a_b < a < a_j
  % used in add_my_pet/get_pars_Danio_rerio

  global v L_b L_m g f L_T kap kJ
  
UH = HL(1);
L = HL(2);

vj = v * L/ L_b;
L_mj = L_m * L/ L_b;
gj = g * L/ L_b;
r = vj * (f/ L - (1 + L_T/ L)/ L_mj)/ (f + g);
dL = r * L /3;
dUH = (1 - kap) * f * L^2 * (gj + L/ L_m)/ (g + f) - kJ * UH;

dHL = [dUH; dL];