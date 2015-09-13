function dtEH = dget_teh_metam(tEH, l)
  %% dtEH = dget_teh_metam(tEH, l)
  %% l: scalar with scaled length  l = L g k_M/ v
  %% tEH: 3-vector with (tau, uE, uH) of embryo and juvenile
  %%   tau = a k_M; scaled age
  %%   uE = (g^2 k_M^3/ v^2) M_E/ {J_EAm}; scaled reserve
  %%   uH = (g^2 k_M^3/ v^2) M_H/ {J_EAm}; scaled maturity
  %% dtEH: 3-vector with (dt/duH, duE/duH, dl/duH)
  %% called by maturity_metam
  
  global k g kap f uHb uHj uHp lT lb lj 

  t = tEH(1); % scaled age
  uE = max(1e-10,tEH(2)); % scaled reserve
  uH = tEH(3); % scaled maturity
 
  if uH < uHb % isomorphic embryo
    r = (g * uE/ l^4 - 1)/ (uE/ l^3 + g); % spec growth rate in scaled time
    dl = l * r/ 3;
    duE =  - uE * l^2 * (g + l)/ (uE + l^3);
    duH = (1 - kap) * uE * l^2 * (g + l)/ (uE + l^3) - k * uH;
  elseif uH < uHj % V1-morphic early juvenile
    rj = g * (f/ lb - 1 - lT/ lb)/ (f + g); % scaled exponential growth rate between b and j
    dl = l * rj/ 3;
    duE = f * l^2 - uE * l^2 * (g * l/ lb + (1 + lT/ l) * l)/ (uE + l^3);
    duH = (1 - kap) * uE * l^2 * (g * l/ lb + l)/ (uE + l^3) - k * uH;
  else % isomorphic late juvenile or adult
    rB = 1/ 3/ (1 + f/ g); % scaled von Bertalnaffy groeth rate
    li = f * lj/ lb - lT;  % scaled ultimate length
    dl = rB * (li - l);
    duE = f * l^2 - uE * l^2 * (g  * lj/ lb + (1 + lT/ l) * l)/ (uE + l^3);
    duH = (1 - kap) * uE * l^2 * (g  * lj/ lb + l)/ (uE + l^3) - k * uH;
    duH = duH * (uH < uHp); % no maturation in adults
  end

  %% then obtain dt/dl, duE/dl, duH/dl, 
  dtEH = [1/dl; duE/dl; duH/dl];
