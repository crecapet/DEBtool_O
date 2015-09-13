function B = beta_43_0(x)
  %% incomplete beta function B_(X^3)(4/3,0)
  %% cf comments at {107}

  B = quad('fnbeta_43_0', 0, x);
  
  %% n = 0:100;
  %% B = .75 * x^(4/3) * (gamma(7/3)/ gamma(4/3)) * \
  %%    sum(gamma(n + 4/3) .* x.^n ./ gamma(n + 7/3));
