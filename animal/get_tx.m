function [tp tx tb lp lx lb] = get_tx(p, f)
% [tp tx tb lp lx lb] = get_tx(p, f)
% Bas Kooijman, 2012/08/18
% p: 6-vector with parameters (see below)
% f: scalar with scaled functional response
% tp, tx, tb: scalars with scaled age at puberty, weaning, birth
% lp, lx, lb: scalers with scaled length at puberty, weaning, birth
% assumes von Bert growth since age 0
% uses dget_lx

  % unpack pars
  g   = p(1); % -, energy investment ratio
  k   = p(2); % -, k_J/ k_M, ratio of maturity and somatic maintenance rate coeff
  lT  = p(3); % -, scaled heating length
  vHb = p(4); % v_H^b = U_H^b g^2 kM^3/ (1 - kap) v^2; U_B^b = M_H^b/ {J_EAm}
  %vHx = p(5); % v_H^x = U_H^x g^2 kM^3/ (1 - kap) v^2; U_B^x = M_H^x/ {J_EAm}
  %vHp = p(6); % v_H^p = U_H^p g^2 kM^3/ (1 - kap) v^2; U_B^p = M_H^p/ {J_EAm}
  if length(p) >= 7
    sF = p(7); % slow development: sF = 1, for sF > 1 intermediate between slow and fast
  else
    sF = 1e8;  % fast development
  end
  [vH l] = ode45(@dget_lx, [0; p(4:6)], 1e-20, [], f, g, k, lT, vHb, sF);
  l(1) = []; lb= l(1); lx = l(2); lp = l(3); li = f - lT;
  tb = - 3 * (1 + sF * f/ g) * log(1 - lb/ sF/ f);
  tx = tb + 3 * (1 + f/ g) * log((li - lb)/ (li - lx));
  tp = tb + 3 * (1 + f/ g) * log((li - lb)/ (li - lp));
end

function dl = dget_lx (vH, l, f, g, k, lT, vHb, sF)
if vH < vHb
  li = sF * f; % -, scaled ultimate length
  f  = sF * f; % -, scaled functional response
else
  li = f - lT;
end
dl = (g/ 3) * (li - l)/ (f + g);  % d/d tau l
dvH = 3 * l^2 * dl + l^3 - k * vH;% d/d tau vH
dl = dl/ dvH;                     % d/d v_H l
end
