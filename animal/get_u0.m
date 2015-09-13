function F = get_u0(U0)
  %% F = get_u0(U0)
  %% U0: scalar with U^0 = M_E^0/{J_EAm}
  %% used to find U^0 such that m_E(a_b) = f
  %% called by fnget_lnpars_s
  
  global v f Hb

  aUL = lsode('dget_aul', [0; U0; 1e-10], [0; Hb]);
  F = aUL(2,2) - f * aUL(2,3)^3/ v;
