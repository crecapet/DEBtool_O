  function dx = dget_LUH(LUH, a)
  % dx = dget_LUH(ULH, a)
  % t: scalar with age
  % LUH: 3-vector with (L, U= M_E/{J_EAm}, H = M_H/{J_EAm}) of embryo
  % dx: 3-vector with (dL/dt, dU/dt, dH/dt)

  global kap, v, kJ, g, Lm
    
  L = LUH(1); % structural length
  U = LUH(2); % scaled reserve M_E/{J_EAm}
  H = LUH(3); % scaled reserve M_H/{J_EAm}
  
  eL3 = U * v; % eL3 = L^3 * m_E/ m_Em
  gL3 = g * L^3;
  SC = L^2 * (1 + L/ (g * Lm)) * g * eL3/ (gL3 + eL3); % J_EC/{J_EAm}
  
  % generate dH/dt, dE/dt, dL/dt
  dH = (1 - kap) * SC - kJ * H;
  dU = - SC;
  dL = v * (eL3 - L^4/ Lm)/ (3 * (eL3 + gL3));
  
  % peack dL/dt, dU/dt, dH/dt, 
  dx = [dL; dU; dH];