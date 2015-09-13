function [tb lb uE0 info] = get_tb1(p, eb, lb0)
  %% [tb lb uE0 info] = get_tb1(p, eb, lb0)
  %% created at 2011/07/05 by Bas Kooijman
  %% p: 1 or 3-vector with parameters g, k_J/ k_M, v_H^b
  %% eb: optional scalar with scaled reserve density at birth (default eb = 1)
  %% lb0: optional scalar with scaled length at birth
  %%     default: lb is obtained from get_lb
  %% tb: scaled age at birth \tau_b = a_b k_M
  %% lb: scalar with scaled length at birth
  %% uE0: scalar with scaled reserve at birth
  
  global g k
  
  if exist('eb','var') == 0
    eb = 1; % maximum value as juvenile
  end
  
  if exist('lb','var') == 0
    if length(p) < 3
      fprintf('not enough input parameters, see get_lb \n');
      tb = [];
      return;
    end
    [lb info] = get_lb(p, eb);
  else
    lb = lb0; info = 1;
  end
  if isempty(lb)
    [lb info] = get_lb(p, eb);
  end

  %% unpack p
  g = p(1);  k = p(2); vHb = p(3);
  
  aul = lsode(@dget_aul1, [0; eb * lb^3/g; lb], [vHb 0]);
  tb = - aul(end,1); uE0 = aul(end,2); l0 = aul(end,3);
 
  if abs(l0) > 1e-4
    info = 0;
  end

 end
  
%% SUBFUNCTION
function daul = dget_aul1(aul, v_H)

  global g k

u_E = aul(2); l = aul(3);
l2 = l * l; l3 = l2 * l; l4 = l3 * l; ul3 = u_E + l3;

du_E = - u_E * l2 * (g + l)/ ul3;
dl = (g * u_E - l4)/ ul3/ 3;
dv_H = u_E * l2 * (g + l)/ul3 - k * v_H;

daul = [1; du_E; dl]/ dv_H;
end