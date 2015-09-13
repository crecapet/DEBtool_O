function EVH = get_evh(a,p,X)
  %% EVH = get_evh(a,p,X)
  %% created by Bas Kooijman 2007/01/28, modified 2011/07/03
  %% a: (na,1)-matrix with ages
  %% p: 12 or 13 -vector with parameters of standard DEB model
  %% X: scalar with food density
  %% EVH: (na,3)-matrix with
  %%   masses of reserve M_E, structure M_V, maturity M_H
  
  global JEAm b yEX yVE v JEM JET kJ kap kapR MHb MHp MV 
  global f Lm LT mEm g

  %% unpack p
  if length(p) == 12
    JEAm = p(1); Fm = p(2); yEX = p(3); yVE = p(4); v = p(5);
    JEM = p(6); kJ = p(7); kap = p(8); kapR = p(9); MHb = p(10);
    MHp = p(11); MV = p(12); JET = 0;
  elseif length(p) == 13
    JEAm = p(1); Fm = p(2); yEX = p(3); yVE = p(4); v = p(5);
    JEM = p(6); JET = p(7); kJ = p(8); kap = p(9); kapR = p(10);
    MHb = p(11); MHp = p(12); MV = p(13);
  else
    fprintf('number of DEB parameters does not equal 12 or 13\n');
    return
  end

  kM = yVE * JEM/ MV; % somatic maintenance rate coefficient
  g = v * MV/ (kap * JEAm * yVE); % energy inverstmet ratio
  VHb = MHb/ JEAm/ (1 - kap); % scaled maturity at birth
  JXAm = JEAm/ yEX; % max spec food uptake rate
  K = JXAm/ Fm; % half saturation coefficient
  f = X ./ (X + K); % scaled functional response
  ME0 = JEAm * initial_scaled_reserve(f, [VHb; g; kJ; kM; v]);

  MEm = JEAm/ v; % [M_Em] = {J_EAm}/v  max reserve density (mass/ vol)
  mEm = MEm/ MV; % max reserve density (mass/ mass)
  Lm = v/ (kM * g); % maximum length
  LT = JET/ JEM; % heating length

  a = [-1e-10; a];
  EVH = lsode('dget_evh', [ME0; 1e-6; 0], a); 
  EVH(1,:) = [];
