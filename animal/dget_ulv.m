function dulv = dget_ulv(ulv,t)
  %% change in state variables during embryo stage
  %% t: a/ k_M
  %% ulv: [u_E, l, v_H]
  %% called by get_eb_min

  global g k ulv_stop test
  
  %% unpack state variables
  u = max(1e-20, ulv(1)); % scaled reserve u = E/(g [E_m] L_m^3)
  l = max(1e-20, ulv(2)); % scaled structural length l = L/ L_m
  v = max(1e-20, ulv(3)); % scaled maturity v = E_H/ (g [E_m] L_m^3 (1 - kap)
  if test == 0
    ul3 = u + l^3;
    du = - u * l^2 * (g + l)/ ul3;
    dl = (g * u - l^4)/ 3/ ul3;
    dv = u * l^2 * (g + l)/ ul3 - k * v;
    if dv < 0
      ulv_stop = ulv;
      test = 1;
    end
  else % after dv = 0
    du = 0;
    dl = 0;
    dv = 0;
  end
    
  %% pack derivatives
  dulv = [du; dl; dv];
