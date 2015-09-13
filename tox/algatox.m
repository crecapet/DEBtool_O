function f = algatox(p, t, c)
  %% f = algatox(p, t, c)
  %% created 2001/09/14 by Bas Kooijman
  %% effects on alga growth:
  %%  (1) partial killing of inoculum
  %%  (2) killing during growth
  %%  (3) increase of costs for growth
  %%  instantaneous equilibrium of internal concentration
  %%  growth is assumed to be nutrient limited
  %%    the nutrient pool is exchanging with a pool that is not available
  %%    to the algae
  %%  algal mass is measured in Optical Densities. The contribution
  %%    of living, dead and ghost might differ. The toxic compound can
  %%    tranfer living into dead biomass, the dead biomass decays to
  %%    ghost biomass according to a first order process.
  %%  the no-effect-conc for the three effects are taken to be the same
  %%    might actually be different, however! 
  %% p: (17,k) matrix with parameters values in p(:,1) (see below)
  %% t: (tn,1) matrix with exposure times
  %% c: (cn,1) matrix with concentrations of toxic compound
  %% f: (nt,nc) matrix with Optical Densities

  %% uses routine dalgatox for integration

  %% application is illustrated in script-file mydata_algatox
 

  global K yEV kN kE k0 kNB kBN c0 cH cy b ci;

  %% unpack parameter vector
  B0 = p(1);  % mM. background nutrient
  N0 = p(2);  % mM, initial nutrient conc
  X0 = p(3);  % mM, initial biomass
  w =  p(4);  % OD/mM, weight of living in optical density (redundant par)
  wd = p(5);  % OD/mM, weight of dead in optical density
  w0 = p(6);  % OD/mM, weight of ghosts in optical density
  K = p(7);   % mM, half saturation constant for nutrient
  yEV = p(8); % mM/mM, yield of reserves on structure
  kN = p(9);  % mM/(mM*h), max spec nutrient uptake rate
  kE = p(10); % 1/h, reserve turnover rate
  kNB = p(11);% 1/h, exchange from nutrient to background
  kBN = p(12);% 1/h, exchange from background to nutrient
  k0 = p(13); % 1/h, dead biomass decay rate to ghost
  c0 = p(14); % mM, no-effect concentration
  cH = p(15); % mM, tolerance conc for initial mortality
  cy = p(16); % mM, tolerance concentration for costs of growth
  b = p(17);  % 1/(mM*h), spec killing rate

  nt = max(size(t)); nc = max(size(c)); f = zeros (nt, nc);

  m0 = kN/ kE; % initial reserve density
  for i = 1:nc % loop across concentrations
    ci = c(i); % current concentration
    F = e^(-max(0,(c(i)-c0)/ cH)); % initial survival prob
    %% initial state vector background, nutrient, reserve, living, dead, ghost
    Y0 = [B0, N0, m0, X0*F, X0*(1-F), 0]';
    Y = lsode('dalgatox', Y0, t); % integrate
    %% unpack state vector
    X = Y(:,4); Xd = Y(:,5); Xg = Y(:,6); % living, dead, ghost
    f(:,i) = w*X + wd*Xd + w0*Xg; % optical density
  end
  
