function dtEH = dget_teh(tEH, l)
  %% dtEH = dget_teh(l, tEH)
  %% l: scalar with scaled length  l = L g k_M/ v
  %% tEH: 3-vector with (tau, uE, uH) of embryo and juvenile
  %%   tau = a k_M; scaled age
  %%   uE = (g^2 k_M^3/ v^2) M_E/ {J_EAm}; scaled reserve
  %%   uH = (g^2 k_M^3/ v^2) M_H/ {J_EAm}; scaled maturity
  %% dtEH: 3-vector with (dt/duH, duE/duH, dl/duH)
  %% called by maturity
  
  global k g kap f uHb uHp lT

  t = tEH(1); % scaled age
  uE = max(1e-10,tEH(2)); % scaled reserve
  uH = tEH(3); % scaled maturity

  %% first obtain dl/dt, duE/dt, duH/dt
  if uH < uHb
      ff = 0;
      llT = 0;
  else
      ff = f;
      llT = lT;
  end
  r = (g * uE/ l^4 - 1 - llT/ l)/ (uE/ l^3 + g); % spec growth rate in scaled time
  dl = l * r/ 3;
  duE = ff * l^2 - uE * l^2 * (g + (1 + llT/ l) * l)/ (uE + l^3);
  if uH < uHp 
    duH = (1 - kap) * uE * l^2 * (g + l)/ (uE + l^3) - k * uH;
  else       % adult
    duH = 0;
  end

  %% then obtain dt/dl, duE/dl, duH/dl, 
  dtEH = [1/dl; duE/dl; duH/dl];
