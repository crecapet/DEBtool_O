function [x info] = newton (fn, x0)
  %% [x info] = newton (fn, x0)
  %% Created: 28 aug 2000 by Bas Kooijman
  %% solves x from 0 = fn(x) by Newton Raphson; starting from x0
  %% Requires: numdif, user-defined function 'fn'
  
  norm = 1e-10;
  imax = 10;
  x = x0;
  
  crit = 1 + norm; i = 1; L = 0; 
  while crit > norm && i <= imax 
    eval(['f = ', fn, '(x);']);
    x = x - numdif(fn, x)\f;
    crit = f.'*f; i = 1 + 1;
  end
  if crit < norm && i < imax
    info = 1;
  else
    x = x0;
    info = 0;
    fprintf(['warning: no convergence within ', num2str(imax), ' steps \n']);
  end
