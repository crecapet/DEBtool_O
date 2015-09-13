function [p elas Jac] = elas_pars_g(par)
  %% [p elas Jac] = elas_pars_g(par)
  %% Bas Kooijman, 2006/09/30
  %% par: 5-vector with quantities at fixed functional response
  %%   1 f   scaled functional response
  %%   2 L_b length at birth
  %%   3 L_m maximum length
  %%   4 a_b age at birth
  %%   5 \dot{r}_B von Bert growth rate
  %% p: 4-vector with compound DEB parameters
  %%   1 VHb   scaled maturity at birth
  %%   2 g     energy investment ratio
  %%   3 kM    somatic maintenance rate coefficient
  %%   4 v     energy conductance
  %% elas: (4,5)-matrix with elasticity coefficients:
  %%   element (i,j): par(j) dp(i)/ (p(i) * dpar(j))
  %% Jac: (4,5)-matrix with Jacobian:
  %%   element (i,j): dp(i)/ dpar(j)

  par = par(:); p = get_pars_g(par);

  del = 1e-6;
  q = par; q(1) = q(1) + del; p1 = get_pars_g(q); dp1 = (p1 - p)/del;
  q = par; q(2) = q(2) + del; p2 = get_pars_g(q); dp2 = (p2 - p)/del;
  q = par; q(3) = q(3) + del; p3 = get_pars_g(q); dp3 = (p3 - p)/del;
  q = par; q(4) = q(4) + del; p4 = get_pars_g(q); dp4 = (p4 - p)/del;
  q = par; q(5) = q(5) + del; p5 = get_pars_g(q); dp5 = (p5 - p)/del;

  Jac = [dp1, dp2, dp3, dp4, dp5];
  elas = [par,par,par,par]' .* Jac ./ [p,p,p,p,p];
 
