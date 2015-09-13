function x = survi_chi (nu, F)
  %% x = survi_chi (nu, F)
  %% created 2002/03/14 by Bas Kooijman
  %% calculates the inverse survivor probability of the Chi-square distribution
  %% nu: scalar with parameter (degrees of freedom)
  %% F: vector with survivor probabilities
  %% x: vector with argument values for which the survivor function
  %%    equals F

  global NU f;
  F = reshape(F, max(size(F)), 1);
  NU=nu; f = F;
  
  x = fsolve('findchi', - nu*log(f)/5);
	     
