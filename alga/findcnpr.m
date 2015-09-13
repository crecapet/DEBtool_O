function f = findcnpr (r)
  %% f = findcnpr (r)
  %% created: 2003/05/18 by Bas Kooijman
  %% called from dcnplim to find growth rate; see p169 of DEB-book
  global m_C m_N m_P k_E yC_EV yN_EV yP_EV ;

  rC = m_C * (k_E - r)/ yC_EV;
  rN = m_N * (k_E - r)/ yN_EV;
  rP = m_P * (k_E - r)/ yP_EV;
  f = 1/(1/rC + 1/rN + 1/rP - 1/(rC+rN)  - 1/(rC+rP)  - 1/(rN+rP) ...
	 + 1/(rC+rN+rP)) - r;
