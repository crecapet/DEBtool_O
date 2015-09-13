function [aEL E0 lb] = get_ael_f(par, F)
  %% [aEL E0 lb] = get_ael_f(par, F)
  %% similar to get_ael, but for foetus
  %%  obsolate, use get_tb_foetus and get_lb_foetus
  %% Bas Kooijman, 2006/08/28
  %% par: 8-vector with parameters
  %% F: n-vector with scaled functional responses
  %% aEL: (n,3)-matrix with a_b, M_E^b, L_b for foetus
  %% E0: n-vector with M_E^0 for foetus
  %% lb: n-vector with L_b/ L_m for foetus

  global kJ kM MV yVE kap MHb v

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
  kM = yVE * JEM/ MV; % som maint rate coefficient
  
  %% Lb if (1 - kap) kM = kap kJ
  Lb = (MHb * yVE * kap/ (MV * (1 - kap)))^(1/3);
  ab = 3 * Lb/ v;
  [ab info] = fsolve('get_ab', ab);
  if info ~= 1
    fprintf('no convergence for a_b\n');
  end
  Lb = ab * v/ 3; % Lb if (1 - kap) kM != kap kJ
  
  nf = size(F,1); aEL = zeros(nf,3); E0 = zeros(nf,1); lb = zeros(nf,1);

  for i = 1:nf
    f = F(i);
    E0(i) = JEAm * (f + (1 - kap) * g * (1 + 0.25 * ab * kM)) * Lb^3/ v;
    aEL(i,:) = [ab, JEAm * f * Lb^3/ v, Lb]; 
    lb(i) = Lb/ Lm;	   
  end