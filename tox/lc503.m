function [cbk err] = lc503(tlc50,p)
  %% [cbk err] = lc503(tlc50,p)
  %% created 2002/01/04 by Bas Kooijman
  %% calculates parameter values, given 3 lc50's
  %% tlc50: (3,2)-matrix with exposure times, lc50's
  %% p: 3-vector with initial estimates for NEC, killing rate, elim rate
  
  global t c;

  t = tlc50(:,1); c = tlc50(:,2);
  [cbk err] = fsolve('fncbk',p);
  
