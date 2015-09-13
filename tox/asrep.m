function Nt = asrep(p, t, c)
  %% Nt = asrep(p, t, c)
  %% created 2002/01/17 by Bas Kooijman; modified 2009/01/15
  %% assimilation effects on reproduction: target is {J_EAm}
  %%  max assim rate linear in internal concentration
  %%  first order toxico kinetics with dilution by growth
  %%  zero internal conc at time zero
  %%  capacity of repoduction buffer equal to zero
  %%  abundant food, internal conc, maturity, reserve are hidden variables
  %% p: (12,k) matrix with parameters values in p(:,1) (see below)
  %% t: (nt,1) matrix with exposure times
  %% c: (nc,1) matrix with concentrations of toxic compound
  %% Nt: (nt,nc) matrix with cumulative number of offspring

  %% application is illustrated in script-file mydata_rep

  global C nc c0 cA ke kap kapR g kJ kM v Hb Hp
  global Lb0

  C = c; nc = size(C,1); % copy concentrations into dummy
  
  %% unpack parameters for easy reference
  c0 = p(1);  % mM, No-Effect-Concentration (external, may be zero)
  cA = max(1e-6,p(2)); % mM, tolerance concentration
  ke = p(3);  % 1/d, elimination rate at L = Lm
  kap = p(4); % -, fraction allocated to growth + som maint
  kapR = p(5);% -, fraction of reprod flux that is fixed into embryo reserve 
  g  = p(6);  % -, energy investment ratio
  kJ = p(7);  % 1/d, maturity maint rate coeff
  kM = p(8);  % 1/d, somatic maint rate coeff
  v  = p(9);  % cm/d, energy conductance
  Hb = p(10); % d cm^2, scaled maturity at birth
  Hp = p(11); % d cm^2, scaled maturity at puberty
  L0 = p(12); % cm, initial body length

  H0 = maturity(L0, 1, [p(4:8), 0, p(9:11)]); % initial scaled maturity
  U0 = L0^3/ v; % initial reserve at max value
  %% initialize state vector; catenate to avoid loops
  X0 = [zeros(nc,1);     % N: cumulative number of offspring
        H0 * ones(nc,1); % H: scaled maturity H = M_H/ {J_EAm}
        L0 * ones(nc,1); % L: length
        U0 * ones(nc,1); % U: scaled reserve U = M_E/ {J_EAm}
        zeros(nc,1)];    % c: scaled internal concentration

  %% prepent zero in time vector to make sure that
  %%   initial state vector corresponds to t = 0
  t = [0;t]; nt = size(t,1);
  Lb = (Hb * v/ (g * (1 - kap))) ^ (1/ 3);
  Lb0 = Lb * ones(nc,1);

  %% integrate changes in state
  Xt = lsode('dasrep', X0, t);
  Nt = Xt(2:nt, 1:nc); % select cum reprod only; remove prepended zero
