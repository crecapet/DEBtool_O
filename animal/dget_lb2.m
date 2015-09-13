function dy = dget_lb2(y,x)
  %% y = x e_H/ (1 - kap); x = g/ (g + e)
  %% (x,y): (0,0) -> (xb, xb eHb/ (1 - kap)) 

  global Lb xb xb3 g k

  x3 = x^(1/ 3);
  l = x3/ (xb3/ Lb - beta0(xb, x)/ 3/ g);
  dy = l + g - y * (k - x)/ (1 - x) * l/ g/ x;
