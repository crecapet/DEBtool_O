function [eb lb uE0 info] = get_eb_min(p, lb0)
  %% [eb info] = get_eb_min(p, lb0)
  %% created 2009/01/15 by Bas Kooijman; modified 2010/09/29
  %% p: 3-vector with parameters: g, k_J/ k_M, v_H^b see get_lb
  %% lb0: optional scalar with initial value for scaled length at birth
  %% eb: 2-vector with e_b such that growth and maturation cease at birth
  %% lb: 2-vector with l_b such that growth and maturity cease at birth
  %% uE0: 2-vector with u_E^0
  %% info: 2-vector with 1's for success
  
  global par_eb_min ulv_stop g k % for fnget_eb_min_G, fnget_eb_min_R and dget_ulv
  
  par_eb_min = p; g = p(1); k = p(2); vHb = p(3);
  
  if k == 1;
    lb = vHb^(1/ 3);
    uEb = [lb^4/ g; vHb * lb/ (g + lb - vHb/ lb^2)];
    eb = g * uEb/ lb^3;
    lb = lb * [1;1];
    uE0 = [get_ue0(p, eb(1)); get_ue0(p, eb(2))];
    info = [1; 1];
    return
  end
  
  if exist('lb0','var') == 0 
    eb0 = get_lb(p, 1);
  else
    eb0 = get_lb(p, 1, lb0);
  end
  
  options = optimset('Display', 'off'); 
  %options = optimset('TolFun', 1e-16, 'TolX', 1e-16, 'Display', 'off');
  nmregr_options('report',0);
  %nmregr_options('max_step_number', 1e4);
  %nmregr_options('max_fun_eval', 1e4);
  %[eb_G info_G] = nmregr('fnget_eb_min_G', eb0, [0 0]);
  [eb_G val_G info_G] = fzero('fnget_eb_min_G', eb0, options);
  uE0_G  = get_ue0(p, eb_G, eb_G);
  if k * vHb > 1e-10
    %[uE0_R info_R] = nmregr('fnget_eb_min_R', eb_G, [0 0]);
    %[eb_R info_R] = nrregr('fnget_eb_min_R', eb_G, [0 0]);
    [uE0_R val_R info_R] = fzero('fnget_eb_min_R', uE0_G, options);
    uEb = ulv_stop(1); lb = ulv_stop(2);
    eb_R = g * uEb/ lb^3; 
    %nmregr_options('report',1);
  else
    uEb = 0; lb = 0; eb_R = 0;uE0_R = 0; info_R = 1;
    %fprintf('warning in get_eb_min: k too small to compute eb_min_R \n');
  end
  
  % compose output
  eb = [eb_G; eb_R]; 
  lb = [eb_G; lb];
  uE0 = [uE0_G; uE0_R];
  if uE0_G <= 0
    info_G = 0;
  end
  if uE0_R <= 0
    info_R = 0;
  end
  info = [info_G; info_R];
