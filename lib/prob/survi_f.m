function x = survi_f (nu, F)
  %% x = survi_f (nu, F)
  %% created 2005/10/02 by Bas Kooijman
  %% calculates the inverse survivor probability of the F distribution
  %% nu: (2,1)-vector with parameters (degrees of freedom; integers)
  %% F: vector with survivor probabilities
  %% x: vector with argument values for which the survivor function
  %%    equals F

  global NU f;
  F = reshape(F, max(size(F)), 1);
  NU=nu; f = F;
  
  x = fsolve('findf', - log(f)/5);
