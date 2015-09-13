function f = fnget_lb2(lb)
  %% f = y(x_b) - y_b = 0; x = g/ (e + g); x_b = g/ (e_b + g)
  %% y(x) = x e_H = x g u_H/ l^3 and y_b = x_b g u_H^b/ l_b^3

  global xb g vHb Lb

  Lb = lb;
  y = lsode('dget_lb2', 0, [1e-10, xb]);
  f = y(2) - xb * g * vHb/ lb^3;
