function [r jEM jVM info] = find_r_1 (m_E, k_E, j_EM, y_EV, j_VM, a)
  %% [r jEM jVM info] = find_r_1 (m_E, k_E, j_EM, y_EV, j_VM, a)
  %% specific growth rate for V1 morph, allowing for shrinking
  %% created: 2007/09/26 by Bas Kooijman, modified 2009/10/29
  %% m_E:  scalar with mol/mol, reserve density
  %% k_E:  scalar with 1/time, reserve turnover rate
  %% j_EM: scalar with mol/time.mol, spec maintenance flux if from reserve
  %% y_EV: scalar with mol/mol, yield of reserve on structure
  %% j_VM: optional scalar with mol/time.mol, spec maintenance flux
  %%       if from structure (default j_EM/ y_EV)
  %% a: optional scalar with preference (default 1e-8)
  %% r:    scalar with 1/time, spec growth rate
  %% jEM: scalar with mol/time.mol, spec maintenance flux for reserve
  %% jVM: scalar with mol/time.mol, spec maintenance flux for structure
  %% info: scalar with numerical failure (0) or success (1)

  if exist('j_VM', 'var') == 0
    j_VM = j_EM/ y_EV;
  end
  if exist('a', 'var') == 0
    a = 1e-8;
  end
  jEM = j_EM; 
  
  i = 1; info = 1; r = 0;
  f = 1; % initiate norm; make sure that Newton-Raphson procedure is started
  while f^2 > 1e-20 && i < 20 % test norm
    j_EC = m_E * (k_E - r);
    C = - j_EC * (j_EC + j_VM);
    B = yPE * C + ((1 - a) * j_EC + j_VM) * kP;
    A = a * j_VM * kP * y_PV;
    jVM = 2 * A * jEM * yPEM/ (2 * A + yPE * (sqrt(B^2 - 4 * A * C) - B));
    r = (m_E * k_E - kP/ y_PE + (y_PV/ y_PE - y_EV) * j_VM)/ (m_E + y_EV);
    i = i + 1;
  end
  if i == 20
    info = 0;  % no convergence
  end 
