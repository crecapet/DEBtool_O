function fn = fno2f_tf(tf, x)
  %% called by o2f for second data point only
  %% f is constant since birth

  global tc g v vOD vOG Lp Lm kap kapR delS
  global E_old L_old LO_old E_obs L_obs LO_obs O_obs % from o2f
  global t f E L LO dLO O % to o2f

  %% unpack vars
  t_obs = tf(1); f = tf(2);

  eLLO = lsode('dfno2f_tf', [E_old; L_old; LO_old], [0; t_obs]);
  t = t_obs; E = eLLO(2,1); L = eLLO(2,2); LO = eLLO(2,3); 
 
  cor_T = spline1(t, tc);
  vT = v * cor_T;  % energy conductance

  SC = cor_T * L ^ 2 * (g + L/ Lm) * E/ (g + E); % p_C/ {p_Am}
  SM = cor_T * kap * L^3/ Lm; % p_M/ {p_Am}
  SG = max(0, kap * SC - SM); % p_G/ {p_Am}
  SD = (SM + (1 - (L > Lp) * kapR) * (1 - kap) * SG)/ kap; % p_D/ {p_Am}
  vSG = vOG * SG;
  svS = vOD * SD + vSG;
  O = vSG ./ svS; % opacity
  dLO = svS * (1 - delS * LO^3/ L^3)/ 3/ LO^2; % change in vol otolith length
  %% dLO is required for initial estimate of next time point

  fn = 1000 * [LO_obs - LO; O_obs - O]; % multiply by 1000 for accuracy
