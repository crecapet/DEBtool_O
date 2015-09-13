function S = ricatti(A,B)
  %% S = ricatti(A,B)
  %% Coding: Bas Kooijman 2005/06/22
  %% A: (n,n)-matrix with cov d/dt X
  %% B: (n,n)-matrix with jacobian of d/dt X
  %% S: (n,n)-matrix with solution of 0 = A + S B' + B S
  
  global a b n
  a = A; b = B;
  
  nA = size(A); nB = size(B); n = nA(1);
  if nA(1) ~= nA(2) || nB(1) ~= nB(2) || nA(1) ~= nB(1)
    printf('sizes do not match \n');
    S = [];
    return
  end

  S = fsolve('fnricatti',B(:));
  S = reshape(S, n, n);
