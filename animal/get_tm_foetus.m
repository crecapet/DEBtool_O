function [t_m S_b S_p info] = get_tm_foetus(p, F, l_b, l_p)
  %% created 2009/02/21 by Bas Kooijman, modified 2009/10/29
  %% calculates mean life span at constant f in case of foetal development
  %%   by integration of cumulative survival prob over length
  %% p: 7-vector with parameters: g k lT vHb vHp ha SG
  %% F: optional scalar with scaled functional response; default: F = 1
  %% l_b: optional scalar with scaled length at birth
  %% l_p: optional scalar with scaled length at puberty
  %% t_m: scalar with scaled mean life span
  %% S_b: scalar with survival probability at birth
  %% S_p: scalar with survival prabability at puberty
  %% info: scalar with indicator for succes (1) or failure (0)
 
  global g k lT ha sG f

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
   
  if exist('l_p', 'var') == 0 && exist('l_b', 'var') == 0 
      [l_p l_b info_lp] = get_lp (p, f);
  elseif exist('l_p', 'var') == 0 || isempty('l_p')
      [l_p l_b info_lp] = get_lp(p, f, l_b);
  end
  
  [uE0, l_b, info_ue0] = get_ue0_foetus([g, k, vHb], f, l_b);
    
  x0 = [uE0; 0; 0; 1; 0]; % initiate uE q h S cS
  x = lsode('dget_tm_foetus', x0, [1e-6; l_b]);
  xb = x(end,:)'; xb(1) = []; % q h S cS at birth
  l = [l_b; l_p; max(l_p + 1e-6, f - lT - 1e-6)];
  x = lsode('dget_tm_adult', xb, l);
  S_b = x(1,3);
  S_p = x(2,3);
  t_m = x(3,4);

  if info_lp == 1 && info_ue0 == 1 && l_p < f - lT
    info = 1;
  else
    info = 0;
    if info_ue0 ~= 1
      fprintf('warning: no convergence for uE0 \n');
    elseif info_lp ~=1
      fprintf('warning: no convergence for l_p \n');
    else
      fprintf('warning: l_p < f - l_T \n');
    end
  end
