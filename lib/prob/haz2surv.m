function S = haz2surv(fnm, t)
  %% S = haz2surv(fnm, t)
  %% coded 2006/02/21 by Bas Kooijman
  %% fnm: string with name of function that specifies hazard
  %%      this function must be of the form: h = haz(x,t)
  %%      where x is a dummy, and t the time
  %% t: n-vector with time points
  %% S = (n,1)-matrix with time and survival probabilities

  t = [-1e-8; t(:)]; % prepent zero for time points
  eval(['ch = lsode(''', fnm, ''', 0, t);']); % cumulative hazard
  S = exp( - ch); S(1) = []; % survival probability
