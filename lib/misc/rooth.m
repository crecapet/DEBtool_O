function [g info] = rooth (h,u,y0,f0,y1,f1)
  %% g = rooth (h,u,y0,f0,y1,f1): root based on hermite interpolation
  %% h: scalar, length of interval for x in (0,h)
  %% u: scalar, value for y(x), typically y0<u<y1 or y1>u>y0
  %% y0: scalar, y0 = y(0)
  %% f0: scalar, f0 = d/dx y(0)
  %% y1: scalar, y1 = y(h)
  %% f1: scalar, f1 = d/dx y(h)
  %% u: scalar, u = y(h) and typically 0 < g < h

  c = [(f1 + f0)/ h^2 - 2 * (y1 - y0)/ h^3;
       3 * (y1 - y0)/ h^2 - (f1 + 2 * f0)/ h ;
       f0; y0 - u];
  g = roots(c); g(im(g)~=0) =[]; g = re(g); g(g < 0 | g > h) = [];
  
  if 1 < length(g)
    g = g(1); info = 2;
  end
  if length(g) == 1
    info = 1;
  else
    info =0;
  end
  g = g(1);

  %% routine test: this should generate the input values
  %% [h,\
  %% c(1)*g^3 + c(2)*g^2 + c(3)*g + c(4) + u,\
  %% u+c(4),\
  %% c(3),\
  %% u+c(1)*h^3 + c(2)*h^2 + c(3)*h + c(4),\
  %% 3*c(1)*h^2 + 2*c(2)*h + c(3)]
