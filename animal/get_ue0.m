function [uE0, lb, info] = get_ue0(p, eb, lb0)
  %% created at 2007/07/27 by Bas Kooijman; modified 2010/05/02
  %% p: 1 or 3 -vector with parameters g, k_J/ k_M, v_H^b, see get_lb
  %% eb: optional scalar with scaled reserve density at birth (default eb = 1)
  %% lb0: optional scalar with scaled length at birth
  %%     default: lb is obtained from get_lb
  %% uE0: scalar with scaled reserve at t=0: U_E^0 g^2 k_M^3/ v^2
  %%      U_E^0 = M_E^0/ {J_EAm}
  %% lb: scalar with scaled length at birth l_b = L_b/ L_m
  %% info: scalar for failure (0) or success (1) of convergence

  if exist('eb', 'var') == 0
    eb = 1; % maximum value as juvenile
  end

  if exist('lb0', 'var') == 0
    if length(p) < 3
      fprintf('not enough input parameters, see get_lb \n');
      uE0 = []; lb = []; info = 0;
      return;
    end
    [lb, info] = get_lb(p, eb);
  else
    lb = lb0; info = 1;
  end

  %% unpack p
  g = p(1);  % energy investment ratio

  xb = g/ (eb + g);
  uE0 = (3 * g/ (3 * g * xb^(1/ 3)/ lb - beta0(0, xb)))^3;
