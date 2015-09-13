function F = get_e0(E0)
  %% F = get_e0(E0)
  %% E0: scalar with M_E^0
  %% F: scalar that is set to zero
  %% used to find M_E^0 such that m_E(a_b) = f m_Em
  %% called by get_ael
  
  global JEAm v f MHb
  
  aEL0 = [0; E0; 1e-10]; H = [0; MHb];
  A = lsode('dget_ael', aEL0, H);
  MEb = A(2,2); Lb = A(2,3);
  F = MEb - f * Lb^3 * JEAm/ v;
