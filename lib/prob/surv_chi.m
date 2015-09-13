function F = surv_chi (nu, x)
  %% F = surv_chi (nu, x)
  %% created 2002/03/14 by Bas Kooijman
  %% calculates the survivor probability of the Chi-square distribution
  %% nu: scalar with parameter (degrees of freedom)
  %% x: vector with argument values
  %% F: vector with survivor probabilities
  
  x = reshape(x, max(size(x)), 1);
  F = 1 - gammai(nu/2,x/2);
