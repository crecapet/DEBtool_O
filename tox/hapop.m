function f = hapop(p, t, c)
  %% f = hapop(p, t, c)
  %% created 2002/02/04 by Bas Kooijman
  %% hazard effects on population growth (of micro-organisms)
  %%  toxico kinetics is instantaneous
  %%  hazard rate linear in (internal) concentration
  %% p: (4,k) matrix with parameters values in p(:,1) (see below)
  %% t: (nt,1) matrix with exposure times
  %% c: (nc,1) matrix with concentrations of toxic compound
  %% f: (nt,nc) matrix with population size

  %% application is illustrated in script-file mydata_pop

  %% unpack parameters for easy reference
  c0 = p(1);  % mM, No-Effect-Concentration (external, may be zero)
  cC = p(2);  % mM, tolerance concentration
  N0 = p(3);  % %, initial population size
  r  = p(4);  % 1/h, specific population growth rate

  rc = r./(1+max(0,(c'-c0)/cC)); % (1,nc)-vector with pop growth rates
  t1 = 1 + 0 * t; % (nt,1)-vector with ones
  t1 = t1*(r./rc);  % (nt,nc)-matrix with rate-ratios
  f = N0*(t1.*exp(t*rc) + 1 - t1); % (nt,nc)-matrix with population size
