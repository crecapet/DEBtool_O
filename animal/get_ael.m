function [aEL E0 lb] = get_ael(par, F)
  %% [aEL E0 lb] = get_ael(par, F)
  %% Bas Kooijman, 2006/08/28
  %% par: 8-vector with parameters
  %% F: n-vector with scaled functional responses
  %% aEL: (n,3)-matrix with a_b, M_E^b, L_b
  %% E0: n-vector with M_E^0
  %% lb: n-vector with L_b/ L_m
  
  global JEAm kap v kJ g Lm f MHb 

  JEAm = par(1); % {J_EAm}
  kap  = par(2); % \kappa
  v    = par(3); % v
  JEM  = par(4); % [J_EM]
  kJ   = par(5); % k_J
  yVE  = par(6); % y_VE
  MHb  = par(7); % M_H^b
  MV   = par(8); % [M_V]

  g = v * MV/ (kap * JEAm * yVE); % energy investment ratio
  Lm = kap * JEAm/ JEM;           % maximum length L_m

  nf = size(F,1); aEL = zeros(nf,3); E0 = zeros(nf,1); lb = zeros(nf,1);
  
  for i = 1:nf % loop over different scaled functional responses
    f = F(i);  % current scaled functional response
    [x E00] = get_ael_f(par, f);          % first get M_E^0 for foetus 
    [E0(i) info] = fsolve('get_e0', E00); % get M_E^0 for egg, copy to output
    if info ~= 1
      fprintf('no convergence for E0\n');
    end

    aEL0 = [0; E0(i); 1e-10]; % set initial (a, M_E, L)
    H = [0; MHb];             % set (M_H^0, M_H^b)
    A = lsode('dget_ael', aEL0, H);
    aEL(i,:) = A(2,:);        % copy (a_b, M_E^b, L_b) to output
    lb(i) = A(2,3)/ Lm;	      % copy l_b to output
  end