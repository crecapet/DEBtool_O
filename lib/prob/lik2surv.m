function s = lik2surv (l,nu)
  %% s = lik2surv (l,nu)
  %% translates values of -2 log lik ratio to survivor prob
  %% on the assumption that the lower and upper tail probabilities are equal
  %% and the log lik-values follow a (distorted) parabola 
  %% l: (n,1)-matrix with -2 log lik ratio values
  %%     one log lik value must be 0
  %% nu: scalar with degrees of freedom of Chi-square distribution
  %% s: (n,1)-matrix with values for survivor function

  s = surv_chi(l,nu);
  [lmin nm] = min(l);
  nl = length(l);
  s(nm:nl)  = 0.5 * (1 - s(nm:nl));
  s(1:nm-1) = 0.5 * (1 + s(1:nm-1));
  