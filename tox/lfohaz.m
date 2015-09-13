function f = lfohaz (p, tci)
  %% f = lfohaz (p, tc)
  %% created 2002/06/04 by Bas Kooijman
  %% standard effects on survival: first-order-mortality
  %%  first order toxico kinetics
  %%  hazard rate linear in the internal conc
  %% p: (4, k) matrix with parameters values in p(:, 1) (see below)
  %% tci: (n, 3) matrix with exposure times, concentrations, indicator
  %%  if indicator equals 1: tci(i, 1) is time-to-death
  %%  else tci(i, 1) is a time when subject i is still alive
  %% f: scalar with minus log likelihood function
  
  %% application is illustrated in script-file mydata_fohaz
  %% routine calls fohaz

  [ih h] = fohaz(p, tci);
  f = sum(ih) - sum(log(h(tci(:, 3) == 1))) ;
  
