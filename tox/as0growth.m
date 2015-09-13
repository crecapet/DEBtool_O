function Lt = as0growth(p, t, c)
  %% Lt = as0growth(p, t, c)
  %% created 2002/02/18 by Bas Kooijman; modified 2006/09/07, 2007/07/10
  %% assimilation effects on growth of ectotherm: target is {J_EAm}
  %%  slow first order toxico kinetics with dilution by growth
  %%    elimination not via reproduction
  %%  max assim rate linear in internal concentration
  %%  abundant food, internal conc and reserve are hidden variables
  %% p: 7-vector with parameters values (see below)
  %% t: (nt,1) matrix with exposure times
  %% c: (nc,1) matrix with concentrations of toxic compound
  %% Lt: (nt,nc) matrix with lengths

  %% application is illustrated in script-file mydata_growth

  global C nc c0t cAt g kM v

  C = c; nc = size(C,1); % copy concentrations into dummy
  
  %% unpack parameters for easy reference
  c0t = p(1); % mM.d, No-Effect-Concentration-time (external, may be zero)
  cAt = p(2); % mM.d, tolerance concentration-time
  ke = p(3);  % 1/d, elimination rate at L = Lm
  g  = p(4);  % -, energy investment ratio
  kM = p(5);  % 1/d, somatic maint rate coeff
  v  = p(6);  % cm/d, energy conductance
  L0 = p(7);  % cm, initial body length
  %% parameter ke at position 3 is not used, but still present in input
  %%   for compatibility reasons with asgrowth
    
  U0 = L0^3/ v; % initial reserve at max value
  %% initialize state vector; catenate to avoid loops
  X0 = [L0 * ones(nc,1); %  L: initial length, 
        U0 * ones(nc,1); %  U: scaled reserve U = M_E/ {J_EAm}
       zeros(nc,1)];     %  ct: scaled internal concentration-time

  %% prepent zero in time vector to make sure that
  %%   initial state vector corresponds to t = 0
  t = [0;t]; nt = size(t,1);

  %% integrate changes in state
  Xt = lsode('das0growth', X0, t);
  Lt = Xt(2:nt,1:nc); % select lengths only; remove prepended zero
