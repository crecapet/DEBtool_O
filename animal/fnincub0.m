function f = fnincub0 (y) 
  %% created 2000/09/30 by Bas Kooijman
  %% subroutine called from 'incub'
  global a x_b;

f = -log(-1+y^(1/3)) + 1/2*log(y^(2/3) + y^(1/3)+1) + ...
  3^(1/2)*atan(1/3*3^(1/2)*(2*y^(1/3)+1))+i*pi-1/6*3^(1/2)*pi;
 f = f/ (a - beta0(y, x_b));