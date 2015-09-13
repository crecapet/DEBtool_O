function p = get_tul_i(par, hul_0)
  %% p = get_tul_i(par, hul_0)
  %% Bas Kooijman, 2007/07/29; modified 2007/09/02
  %% par: 3-vector with
  %%   1 g     % energy investment ratio
  %%   2 k     % ratio of maturity and somatic maintenance rate coefficients
  %%   3 vHb   % scaled maturity at birth
  %%             (g^2 k_M^3/ v^2) M_H^b/ ((1 - kap) {J_EAm})
  %% hul_0: 3-vector with initial scaled maturity, reserve, length
  %% p: 3-vector with tau_b, u_E^b, l_b

  global k g % for dget_tul

  %% unpack input parameters
  g   = par(1); % energy investment ratio
  k   = par(2); % ratio of maturity and somatic maintenance rate coefficients
  vHb = par(3); % scaled maturity at birth
  %%              (g^2 k_M^3/ v^2) M_H^b/ ((1 - kap) {J_EAm})


  vH0 = hul_0(1); tul_0 = hul_0; tul_0(1) = 0;
  tul = lsode('dget_tul', tul_0, [vH0; vHb]);

  %% prepare output
  p = tul(2,:)';
