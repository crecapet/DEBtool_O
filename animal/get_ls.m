function [ls lj lp lb info] = get_ls(p, f, lb0)
  %% [ls lj lp lb info] = get_lj (p, f, lb0)
  %% created at 2011/07/21 by Bas Kooijman, modified 2013/07/16
  %% Isomorph, but V1-morph between vHs and vHj, with vHb> vHs> vHj > vHp
  %% p: 7-vector with parameters: g, k, l_T, v_H^b, v_H^s, v_H^j, v_H^p
  %% f: optional scalar with scaled functional responses (default 1)
  %% lb0: optional scalar with scaled length at birth
  %% ls: scalar with scaled length at start of V1-stage
  %% lj: scalar with scaled length at end of V1-stage
  %% lp: scalar with scaled length at puberty (start reprod of iso-stage)
  %% lb: scalar with scaled length at birth (start feeding of iso-stage)
  %% info: indicator equals 1 if successful
  
  % l = L/ L_m with L_m = kap {p_Am}/ [p_M] where {p_Am} is of embryo
  % {p_Am} and v increase between maturities v_H^s and v_H^j till
  % {p_Am} l_j/ l_b  and v l_j/ l_b at metamorphosis
  % after metamorphosis l increases from l_j till l_i = f l_j/ l_s - l_T
  % l can thus be larger than 1.

  global f_get g k li lb_j lT

  %% unpack pars
  g   = p(1); % energy investment ratio
  k   = p(2); % k_J/ k_M, ratio of maturity and somatic maintenance rate coeff
  lT  = p(3); % scaled heating length {p_T}/[p_M]
  vHb = p(4); % v_H^b = U_H^b g^2 kM^3/ (1 - kap) v^2; U_B^b = M_H^b/ {J_EAm}
  vHs = p(5); % v_H^s = U_H^s g^2 kM^3/ (1 - kap) v^2; U_B^s = M_H^s/ {J_EAm}
  vHj = p(6); % v_H^j = U_H^j g^2 kM^3/ (1 - kap) v^2; U_B^j = M_H^j/ {J_EAm}
  vHp = p(7); % v_H^p = U_H^j g^2 kM^3/ (1 - kap) v^2; U_B^j = M_H^j/ {J_EAm}

  if exist('f','var') == 0 
    f = 1; f_get = 1;
  elseif  isempty(f)
    f = 1; f_get = 1;
  else
    f_get = f;
  end
  
  % get lb
  if exist('lb0','var') == 0 
    lb0 = [];
    [lb info] = get_lb([g; k; vHb], f, lb0);
  else
    info = 1;
    lb = lb0;
  end
  
  % get ls
  li = f; % global in dget_lp
  ls = lsode('dget_lp', lb, [vHb; vHs]); ls = ls(end);

  % get lj
  lb_j = ls; % global in dget_lj
  lj = lsode('dget_lj', ls, [vHs; vHj]); lj = lj(end);
  
  % get lp
  li = f * lj/ls; % global in dget_lp
  lp = lsode('dget_lp', lj, [vHj; vHp]); lp = lp(end);
  
  if lT > f - lb
    info = 0;
  end
