function [aULH U0] = get_aulh(par)
  %% [aUL U0] = get_aulh(par)
  %% Bas Kooijman, 2006/09/10
  %% par: 6-vector with parameters
  %% aULH: 3-vector with a_b, U^b, L_b, H^b at abundant food
  %% U0: scalar with U^0 at abundant food
  %%   U = M_E/{J_EAm}; U^0 = M_E^0/{J_EAm} = M_E(0)/{J_EAm}
  %%   dim(U) = t L^2
  
  global kap v kJ g Lb Lm 

  kap  = par(1);
  v    = par(2);
  kM   = par(3);
  kJ   = par(4);
  g    = par(5);
  Lb   = par(6);


  Lm = v/ (kM * g); % maximum length
  
  [x U00] = get_aulh_f(par);         % first get U^0 for foetus 
  [U0 info] = fsolve('get_u0', U00); % get U^0 for egg, copy to output
  if info ~= 1
    printf('no convergence for U0\n');
  end

  aUH0 = [0; U0; 0]; % set initial (a, U, H)
  L = [0; Lb];       % set length range
  A = lsode('dget_auh', aUL0, L);
  aULH = A(2,[1 2 3 3]);   % copy (a_b, U^b, H_b) to output
  aULH(3) = Lb;
  