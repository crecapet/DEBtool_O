function [p uE0 info] = get_tul(par, eb, lb0)
  %% [p uE0 info] = get_tul(par, eb, lb0)
  %% Bas Kooijman, 2007/07/24
  %% par: 3-vector with
  %%   1 g     % energy investment ratio
  %%   2 k     % ratio of maturity and somatic maintenance rate coefficients
  %%   3 vHb   % scaled maturity at birth
  %%             (g^2 k_M^3/ v^2) M_H^b/ ((1 - kap){J_EAm})
  %% eb: scalar with scaled reserve density at birth (optional)
  %% lb0: optional scalar with initial estimate for scaled length at birth
  %% p: 3-vector with tau_b, u_E^b, l_b
  %% uE0: scalar with u_E^0 = (g^2 k_M^3/ v^2) M_E^0/ {J_EAm}
  %% info: scalar with value 1 if successful

  global k g vHb f % for dget_tul

  %% unpack input parameters
  g   = par(1); % energy investment ratio
  k   = par(2); % ratio of maturity and somatic maintenance rate coefficients
  vHb = par(3); % scaled maturity at birth
  %%              (g^2 k_M^3/ v^2) M_H^b/ ((1 - kap) {J_EAm})

  if exist('eb', 'var') == 0
    f = 1; % maximum value as juvenile
  else
    f = eb; % to make scaled functional response global
  end

  if exist('lb0', 'var') == 0 || k == 1
    lb = vHb^(1/3); % exact solution for k = 1
  else
    lb = lb0;
  end

  [lb info] = fsolve('fnget_tul', lb);
  uE0 = get_ue0(par,f,lb);

  l0 = 1e-6;
  vH0 = uE0 * l0^2 * (g + l0)/ (uE0 + l0^3)/ k;
  tul = lsode('dget_tul', [0; uE0; l0], [vH0; vHb]);

  %% prepare output
  p = tul(2,:)';
