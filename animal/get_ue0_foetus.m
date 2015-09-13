function [uE0 lb tb info] = get_ue0_foetus(p, eb, lb0)
  %% [uE0 lb tb info] = get_ue0_foetus(p, eb, lb0)
  %% created at 2007/09/03 by Bas Kooijman
  %% p: 1 or 3 -vector with parameters g, k_J/ k_M, v_H^b
  %% eb: optional scalar with scaled reserve density at birth (default eb = 1)
  %% lb0: optional scalar with scaled length at birth
  %%     default: lb is obtained from get_lb
  %% uE0: scalar with scaled reserve at t=0: U_E^0 g^2 k_M^3/ v^2
  %%      U_E^0 = M_E^0/ {J_EAm}
  %% lb: scalar with scaled length at birth
  %% tb: scalar with scaled age at birth
  %% info: scalar with failure (0) or success (1) of convergence

  %% unpack p
  g = p(1);  % energy investment ratio

  if exist('eb', 'var') == 0
    eb = 1; % maximum value as juvenile
  end

  if exist('lb0', 'var') == 0
    if length(p) < 3
      fprintf('not enough input parameters, see get_lb \n');
      uE0 = []; lb = []; info = 0;
      return;
    end
    [lb tb info] = get_lb_foetus(p);
  else
    lb = lb0; tb = 3 * lb/ g; info = 1;
  end

  uEb = eb * lb^3/ g;
  uE0 = uEb + lb^3 + 3 * lb^4/ 4/ g;
