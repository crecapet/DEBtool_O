function [lb info] = get_lb2(p, eb, lb0)
  %% [lb info] = get_lb2(p, eb, lb0)
  %% created 2007/07/26 by Bas Kooijman; modified 2013/08/21
  %% p: 4-vector with parameters: g, k_J/ k_M, v_H^b (see below)
  %% eb: optional scalar with scaled reserve density at birth (default eb = 1)
  %% lb0: optional scalar with initial estimate for scaled length at birth
  %% lb: scalar with scaled length at birth
  %% info: indicator equals 1 if successful
  %% solves y(x_b) = y_b  with shooting method
  %%   y(x) = x e_H = x g u_H/ l^3 and y_b = x_b g u_H^b/ l_b^3
  %% calls dget_lb2 and fnget_lb2

  global xb xb3 kap g k vHb
  
  %% unpack p
  g = p(1);   % energy investment ratio
  k = p(2);   % k_J/ k_M, ratio of maturity and somatic maintenance rate coeff
  vHb = p(3); % v_H^b = U_H^b g^2 kM^3/ (1 - kap) v^2; U_B^b = M_H^b/ {J_EAm}

  info = 1;

  if exist('lb0','var') == 0 || k == 1
    lb = vHb ^ (1/3); % exact solution for k = 1
    if k == 1
      return;
    end
  elseif isempty(lb0)
    lb = vHb^(1/ 3); % exact solution for k = 1     
  else
    lb = lb0;
  end
  if exist('eb','var') == 0
    eb = 1;
  elseif isempty(eb)
    eb = 1;
  end

  xb = g/ (eb + g); xb3 = xb^(1/ 3);
  
  options = optimset('Display','off');
  [lb, flag, info] = fzero('fnget_lb2',lb,options);
  if lb < 0 || lb > 1
      info = 0;
  end

  end


  %% subfunctions

  function f = fnget_lb2(lb)
  %% f = y(x_b) - y_b = 0; x = g/ (e + g); x_b = g/ (e_b + g)
  %% y(x) = x e_H = x g u_H/ l^3 and y_b = x_b g u_H^b/ l_b^3

  global xb g vHb Lb

  Lb = lb;
  y = lsode('dget_lb2', 0, [1e-10, xb]);
  f = y(2) - xb * g * vHb/ lb^3;
  end

  function dy = dget_lb2(y,x)
  %% y = x e_H/ (1 - kap); x = g/ (g + e)
  %% (x,y): (0,0) -> (xb, xb eHb/ (1 - kap)) 

  global Lb xb xb3 g k

  x3 = x^(1/ 3);
  l = x3/ (xb3/ Lb - beta0(x, xb)/ 3/ g);
  dy = l + g - y * (k - x)/ (1 - x) * l/ g/ x;
  end
  