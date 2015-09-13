function dl = fnembryo_l(l)
  global TA Ti Te rBi TM TG T
  %% p_T+ = p_TM + p_TG = p_TM* l^3 + p_TG* rB (1 - l) 3 l^2 , Eq(4.37){153}
  %% d/dt Tb = alpha_T p_T+ - k_be(T_b - T_e), see {258} at speudo equil
  T = l^2 * (TM * l + TG * 3 * rBi * (1 - l));
  [Tb err] = fsolve('fnembryo_T',Te + T); 
  rB = rBi * exp(TA/Ti - TA/Tb);
  dl = rB * (1 - l);
