function t_b = incub (f,g,l_b,kT_M)
  %% t_b = incub (f,g,l_b,kT_M)
  %% created 2000/08/17 by Bas Kooijman
  %% calculates age at birth t_b

  global a x_b;

  x_b = g/(f + g); a = 3*g*x_b^(1/3)/l_b;
  t_b =  (3/kT_M)*quad('fnincub', 0, x_b);
  
