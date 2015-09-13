function [lp lb info] = get_lp_foetus (p, f, lb0)
  %  [lp info] = get_lp_foetus (p, f, lb0)
  %  created at 2011/04/11 by Bas Kooijman, modified 2011/09/14
  %  p: 5-vector with parameters: g, k, l_T, v_H^b, v_H^p 
  %  f: optional scalar with scaled functional responses (default 1)
  %  lb0: optional scalar with scaled length at birth
  %      or optional 2-vector with scaled length, l, and scaled maturity, vH
  %      for a juvenile that is now exposed to f, but previously at another f
  %      lb0 should be specified for foetal development
  %  lp: scalar with scaled length at puberty
  %  lb: scalar with scaled length at birth
  %  info: indicator equals 1 if successful

  global f_get g k lT

  %% unpack pars
  g   = p(1); % energy investment ratio
  k   = p(2); % k_J/ k_M, ratio of maturity and somatic maintenance rate coeff
  lT  = p(3); % scaled heating length {p_T}/[p_M]
  vHb = p(4); % v_H^b = U_H^b g^2 kM^3/ (1 - kap) v^2; U_B^b = M_H^b/ {J_EAm}
  vHp = p(5); % v_H^p = U_H^p g^2 kM^3/ (1 - kap) v^2; U_B^p = M_H^p/ {J_EAm}

  if exist('f','var') == 0 
    f = 1; f_get = 1;
  elseif  isempty(f)
    f = 1; f_get = 1;
  else
    f_get = f;
  end
  if exist('lb0','var') == 0
      lb0 = [];
      [lb info] = get_lb_foetus([g; k; vHb], f);
  elseif isempty(lb0)
      [lb info] = get_lb_foetus([g; k; vHb], f);
  elseif length(lb0) < 2
      info = 1;
      lb = lb0;
  else % for a juvenile of length l and maturity vH
      l = lb0(1); vH = lb0(2); % juvenile now exposed to f
      [lb info] = get_lb_foetus([g; k; vHb], f);
  end
  if k == 1
    lp = vHp^(1/3);
  elseif length(lb0) < 2
    if f * lb^2 * (g + lb) < vHb * k * (g + f) 
       lp = [];
       info = 0;
       fprintf('Warning in get_lp: maturity goes not increase at birth \n');
    else
       lbp = lsode(lb, 'dget_lp', [vHb; vHp]); 
       lp = lbp(end);
    end
  else % for a juvenile of length l and maturity vH
    if f * l^2 * (g + l) < vH * k * (g + f) 
       lp = [];
       info = 0;
       fprintf('Warning in get_lp: maturity goes not increase initially \n');
    elseif vH + 1e-4 < vHp 
      lbp = lsode('dget_lp', l, [vH; vHp]); 
      lp = lbp(end);
    else
      lp = l;
      info = 0;
      fprintf('Warning in get_lp: initial maturity exceeds puberty threshold \n')
    end
  end