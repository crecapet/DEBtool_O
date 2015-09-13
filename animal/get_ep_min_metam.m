function [ep info] = get_ep_min_metam(p)
  %% ep = get_ep_min_metam(p)
  %% created 2011/05/03 by Bas Kooijman, modified 2011/07/27
  %% p: 6-vector with parameters: g k lT v_H^b v_H^j v_H^p (cf get_lj)
  %% ep: scalar with e_p such that growth and maturation cease at puberty
  %% info: scalar for failure (0) or success (1)

  g   = p(1); % energy investment ratio
  k   = p(2); % k_J/ k_M, ratio of maturity and somatic maintenance rate coeff
  lT  = p(3); % scaled heating length {p_T}/[p_M]
  vHb = p(4); % v_H^b = U_H^b g^2 kM^3/ (1 - kap) v^2; U_B^b = M_H^b/ {J_EAm}
  vHj = p(5); % v_H^j = U_H^j g^2 kM^3/ (1 - kap) v^2; U_B^j = M_H^j/ {J_EAm}
  vHp = p(6); % v_H^p = U_H^j g^2 kM^3/ (1 - kap) v^2; U_B^j = M_H^j/ {J_EAm}

  ep_0 = 0; ep_1 = 1; % lower and upper boundary for ep
  norm = 1; i = 0; % initialise norm and step number
  
  while i < 200 && abs(norm) > 1e-6 % bisection method
    i = i + 1;
    ep = (ep_0 + ep_1)/ 2;
    [lj lp lb] = get_lj([g k lT vHb vHj], ep);
    norm = k * vHp - (ep * lj/ lb - lT)^2 * ep * lj/lb;
    if norm > 0
        ep_0 = ep;
    else
        ep_1 = ep;
    end
  end
    
  if i == 200
    info = 0;
    fprintf('get_ep_min_metam warning: no convergence for f in 200 steps\n')
  else
    info = 1;
    %fprintf(['get_ep_min_metam warning: successful convergence for f in ', num2str(i), ' steps\n'])
  end
