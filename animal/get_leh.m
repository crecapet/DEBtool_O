function leh = get_leh(t, p, F)
  %% created 2009/01/28 by Bas Kooijman
  %% calculates trajectories at constant food
  %% t: n-vector with scaled times
  %% p: 7-vector with parameters: g k lT vHb vHp ha SG
  %% F: scalar with functional response (optional, default 1)
  %% leh: (n,7)-matrix with 
  %%   scaled length l, scaled reserve uE, scaled maturity uH,
  %%   acelleration q, hazard h, survival prob S, cum surv prob cS

 
  global ha sG vHb vHp k g f lT

  %% unpack pars
  g   = p(1); % energy investment ratio
  k   = p(2); % k_J/ k_M, ratio of maturity and somatic maintenance rate coeff
  lT  = p(3); % scaled heating length {p_T}/[p_M]Lm
  vHb = p(4); % v_H^b = U_H^b g^2 kM^3/ (1 - kap) v^2; U_B^b = M_H^b/ {J_EAm}
  vHp = p(5); % v_H^p = U_H^p g^2 kM^3/ (1 - kap) v^2; U_B^p = M_H^p/ {J_EAm}
  ha  = p(6); % h_a/ k_M^2, scaled Weibull aging acceleration
  sG  = p(7); % Gompertz stress coefficient
  
  if exist('F', 'var') == 0
    f = 1;
  elseif isempty(F)
    f = 1;
  else
    f = F;
  end

  [uE0 lb info] = get_ue0([g, k, vHb], f); % scaled intial reserve
  if info ~= 1
      fprintf('warning: no convergence for uE0 \n');
  end
  
  x0 = [lb/1000; uE0; 1e-12; 0; 0; 1; 0];
  if t(1) == 0
    leh = lsode('dget_tm', x0, t);           
  else
    t = [0; t];
    leh = lsode('dget_tm', x0, t); 
    leh(1,:) = [];
  end
