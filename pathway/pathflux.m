function [jr jp t] = pathflux (j0,par,t0)
  %% [jr jp t] = pathflux (j0,par,t0)
  %% created 2002/06/24 by Bas Kooijman
  %% calculates arrival, rejection and production fluxes in pathway of length n
  %% par: (n,5)-matrix with rho_i, alpha_i-1, k_i, M_{S_i}, y_{X_i,X_i-1}
  %% j0: nj-vector with substrate flux to linear pathway
  %% jr: (nj,n+1)-matrix rejection fluxes
  %% jp: (nj,n+1)-matrix production fluxes
  %% t:  (nj,n+1)-matrix unbounded fractions
  global r a k m y  n j;

  [n,np] = size(par);
  if np<5
    par = [par, ones(n,2)];
  end
  r = par(:,1); a = par(:,2); k = par(:,3); m = par(:,4); y = par(:,5);
  nj=length(j0); jr = zeros(nj,n+1); jp = jr; t = jr;

  if exist('t0', 'var')==0
    t0 = 0.5*ones(n,1);
  end

  for f=1:nj
    j = j0(f);
    
  
    t0 = fsolve('fnpathflux', t0);
    t(f,:) = t0;

  end
