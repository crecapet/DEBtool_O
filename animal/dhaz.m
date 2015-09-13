function d = dhaz(x, t)
  %% created 2000/09/06 by Bas Kooijman
  %% routine called by "shtime2survival"; d(i) = d/dt x(i)
  %% x(1)=el^3, x(2)=l, x(3)=\int l^3 dt, x(4)=h, x(5)=S, x(6)=\int S dt
  %% e: scaled reserve density       l: scaled length
  %% h: hazard rate                  S: survival probability
  
  global kT_M hT_a l_b g f l_h;

  l3 = x(2)^3;
  if (x(2) < l_b)
    d(2) = (kT_M*g/3)*(x(1) - (x(2) + l_h)*l3)/(x(1) + g*l3);
    d(1) = (3*d(2) - g*kT_M)*x(1)/x(2);
  else
    d(2) = (kT_M*g/3)*(f - x(2) - l_h)/(f + g);
    d(1) = f*3*x(2)^2*d(2);
  end
  d(3) = l3;
  d(4) =  hT_a*(1 + kT_M*x(3)/l3) - x(4)*3*d(2)/x(2);
  d(5) = - x(4)*x(5);
  d(6) = x(5);

