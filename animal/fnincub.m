function fn = fnincub (x)
  %% created 2000/08/17 by Bas Kooijman
  %% subroutine called from "incub"

  global a x_b;

  fn = 1/((1 - x)*x^(2/3)*(a - beta0(x,x_b)));
