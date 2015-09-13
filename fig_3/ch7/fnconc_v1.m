function dX = fnconc_v1(X)
  global K k
  dX = - k * X/ (K+X);
