function aHEL = egg_j(par, HEL0, a)
  %% aHEL = egg(par, HEL0, a)
  %% Bas Kooijman, 2006/08/28
  %% par: 8-vector with parameters
  %% HEL0: 3-vector with M_H^0, M_E^0, L_0
  %% a: n-vector with ages
  %% aHEL: (n,4)-matrix with a, M_H, M_E, L
  %% see further mydata_egg_j
  
  global JEAm kap v kJ g Lm

  JEAm = par(1); % {J_EAm}
  kap  = par(2); % \kappa
  v    = par(3); % v
  JEM  = par(4); % [J_EM]
  kJ   = par(5); % k_J
  yVE  = par(6); % y_VE
  MHb  = par(7); % M_H^b
  MV   = par(8); % [M_V]

  g = v * MV/ (kap * JEAm * yVE); % energy investment ratio
  Lm = kap * JEAm/ JEM; % maximum length

  aHEL = [a, lsode('degg_j', HEL0, a)];
