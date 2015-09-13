function fn = fno2f(Df, x)
  %% Df: scalar with d/dt f(t)
  %% x: dummy for application of nmregr
  %% called by o2f for growth conditions
  %% f changes linearly from f_old to f_obs at rate df

  global tc g v vOD vOG Lb Lp Lm kap kapR
  global t_old E_old L_old LO_old O
  global t_obs E_obs L_obs LO_obs O_obs% from o2cf
  global df cor_T % to o2cf

  df = Df; % copy to allow transfer as global to dfno2f_tel
  teL = lsode('dfno2f_tel', [t_old; E_old; L_old], [LO_old; LO_obs]);
  t_obs = teL(2,1); E_obs = teL(2,2); L_obs = teL(2,3);

  cor_T = spline1(t_obs, tc);
  vT = v * cor_T;  % energy conductance

  E = E_obs; L = L_obs; LO = LO_obs; 
  SC = cor_T * L ^ 2 * (g + L/ Lm) * E/ (g + E); % p_C/ {p_Am}
  SM = cor_T * kap * L^3/ Lm; % p_M/ {p_Am}
  SG = max(0, kap * SC - SM); % p_G/ {p_Am}
  SD = (SM + (1 - (L > Lp) * kapR) * (1 - kap) * SG)/ kap; % p_D/ {p_Am}
  vSG = vOG * SG;
  svS = vOD * SD + vSG;
  O = vSG ./ svS; % opacity

  fn = 1000 * (O_obs - O); % multiply by 1000 for accuracy
