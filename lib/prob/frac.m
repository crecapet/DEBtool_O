function p = frac(z,x)
  %% p = frac(z,x)
  %% Created 2002/04/21 by Bas Kooijman
  %% calculates the empirical survivor probabilities
  %% z: n-vector of trials from some p.d.f. or prob distr.
  %% x: m-vector of argument values
  %% p: m-vector of fractions of z-values that exceed x

  nx = length(x);
  nz = length(z);
  p=x;
  for i=1:nx
    p(i)=sum(x(i)<z);
  end
  p = p/nz;
