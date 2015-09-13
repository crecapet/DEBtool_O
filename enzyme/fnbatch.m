function f = fnbatch(X,t)
  %% f = fnbatch(X,t)
  %% created 2000/10/17 by Bas Kooijman
  %% called by lsode in "batch"
  
  global fname; % function name for enzyme mediated transformation rate
  global par; n_A = par(1); n_B = par(2);

  eval(['J_C = ', fname, '(X(1), X(2), n_A, n_B);']);
  f(1) = - n_A*J_C; % substrate A
  f(2) = - n_B*J_C; % substrate B 
  f(3) = J_C;       % product C
