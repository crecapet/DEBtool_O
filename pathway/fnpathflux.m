function f = fnpathflux (t)
  %% f = fnpathflux (t)
  %% created 2002/12/22 by Bas Kooijman
  %% subroutine for "pathflux"
  %% global rho_i, alpha_i-1, k_i, M_{S_i}, y_{X_i,X_i-1}, j0
  global r a k m y n j;

  t1 = [t(2:n),1]; a1 = [a(2:n),0];
  jp = (1 - a1 .* (1 - t1) - t) .* k .* y .* [1,m(2:n)] ./ m;
  jp = [j/m(1),jp(1:n-1)];
  
  f = t .* (k + (1 - a) .* r .* jp) - k .* (1 - a + a .* t1) + a .* r .* jp;
