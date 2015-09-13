function dx = dget_tul(tul, vH)
  %% dx = dget_aul(tul, vH)
  %% tul: 3-vector with (tau, u_E, l) of embryo
  %%  tau = a k_M; u_E = (g^2 k_M^3/ v^2) M_E/ {J_EAm}; l = L g k_M/ v
  %% vH: scalar with v_H = (g^2 k_M^3/ v^2) M_H/ ((1 - kap) {J_EAm})
  %% dx: 3-vector with (dt/dvH, duE/dvH, dl/dvH)
  
  global k g

  t = tul(1); % scaled age
  uE = max(1e-10,tul(2)); % scaled reserve
  l = tul(3); % scaled structural length
  
  %% first generate duH/dt, duE/dt, dl/dt
  duE = - uE * l ^2 * (g + l)/ (uE + l^3);
  dvH =  max(1e-10, - duE - k * vH);
  dl = (1/3) * (g * uE - l^4)/ (uE + l^3);

  %% then obtain dt/dvH, duE/dvH, dl/dvH, 
  dx = [1/dvH; duE/dvH; dl/dvH];
