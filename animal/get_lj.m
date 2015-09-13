function [lj lp lb info] = get_lj(p, f, lb0)
  %% [lj lp lb info] = get_lj (p, f, lb0)
  %% created at 2010/02/10 by Bas Kooijman, modified 2011/09/14
  %% Isomorph, but V1-morph between vHb and vHj
  %% p: 6-vector with parameters: g, k, l_T, v_H^b, v_H^j, v_H^p
  %%    if p is a 5-vector, output lp is empty
  %% f: optional scalar with scaled functional responses (default 1)
  %% lb0: optional scalar with scaled length at birth
  %% lj: scalar with scaled length at metamorphosis
  %% lp: scalar with scaled length at puberty
  %% lb: scalar with scaled length at birth
  %% info: indicator equals 1 if successful
  
  % l = L/ L_m with L_m = kap {p_Am}/ [p_M] where {p_Am} is of embryo
  % {p_Am} and v increase between maturities v_H^b and v_H^j till
  % {p_Am} l_j/ l_b  and v l_j/ l_b at metamorphosis
  % after metamorphosis l increases from l_j till l_i = f l_j/ l_b - l_T
  % l can thus be larger than 1.
  
  global f_get g k li lT lb_j

  n_p = length(p);

  %% unpack pars
  g   = p(1); % energy investment ratio
  k   = p(2); % k_J/ k_M, ratio of maturity and somatic maintenance rate coeff
  lT  = p(3); % scaled heating length {p_T}/[p_M]
  vHb = p(4); % v_H^b = U_H^b g^2 kM^3/ (1 - kap) v^2; U_B^b = M_H^b/ {J_EAm}
  vHj = p(5); % v_H^j = U_H^j g^2 kM^3/ (1 - kap) v^2; U_B^j = M_H^j/ {J_EAm}
  if n_p > 5
    vHp = p(6); % v_H^p = U_H^j g^2 kM^3/ (1 - kap) v^2; U_B^j = M_H^j/ {J_EAm}
  end

  if exist('f','var') == 0 
    f_get = 1; f = 1;
  elseif  isempty(f)
    f_get = 1; f = 1;
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
  
  % get lj
  li = f - lT; % global in dget_lj
  lb_j = lb;   % global in dget_lj
  lj = lsode('dget_lj', lb, [vHb; vHj]); lj = lj(end);
  
  % get lp
  if n_p > 5
    li  = f * lj/ lb - lT; % global in dget_lp
    lp = lsode('dget_lp', lj, [vHj; vHp]); lp = lp(end);
  else
    lp = [];
  end
  
  if lT > f - lb
    info = 0;
  end
