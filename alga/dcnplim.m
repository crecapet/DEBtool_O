function dXt = dcnplim (Xt,t)
  %% dXt = dcnplim (Xt,t)
  %% created: 2003/05/22 by Bas Kooijman
  %% change in state variables of a batch reactor,
  %%   see p170-171 of DEB-book
  %%   excreted reserves are available for assimilation
  %%   simultaneous C,N,P limitation  

  global K_C K_N K_P j_Cm j_Nm j_Pm k_E yC_EV yN_EV yP_EV J_C0 J_N0 k_C0;
  global kap_C kap_N kap_P;
  global C N P m_C m_N m_P;
  
  %% unpack Xt
  C = Xt(1);  N = Xt(2);  P = Xt(3);
  m_C = Xt(4); m_N = Xt(5); m_P = Xt(6); X = Xt(7);

  r = fsolve('findcnpr', findcnpr(0)); % 1/d, spec-growth rate

  j_C = j_Cm*C/(K_C + C); %
	     % mol/mol.d, spec assimilation flux of C
  j_N = j_Nm*N/(K_N + N);
	     % mol/mol.d, spec assimilation flux of N 
  j_P = j_Pm*P/(K_P + P);
	     % mol/mol.d, spec assimilation flux of P

  dC = - j_C*X + (1-kap_C)*((k_E - r)*m_C - r)*X - k_C0*C + J_C0;
				% M/d, change in CO2 concentration
  dN = - j_N*X + (1-kap_N)*((k_E - r)*m_N - r*yN_EV)*X + J_N0;
	     % M/d, change in nitrogen concentration
  dP = - j_P*X + (1-kap_P)*((k_E - r)*m_P - r*yP_EV)*X;
	     % M/d, change in phosphorous concentration
  dm_C = j_C - (1-kap_C)*(k_E-r)*m_C - kap_C*yC_EV*r - r*m_C;
	     % mol/mol.d, change in C-reserve density
  dm_N = j_N - (1-kap_N)*(k_E-r)*m_N - kap_N*yN_EV*r - r*m_N;
	     % mol/mol.d, change in N-reserve density
  dm_P = j_P - (1-kap_P)*(k_E-r)*m_P - kap_P*yP_EV*r - r*m_P;
	     % mol/mol.d, change in P-reserve density
  dX = r*X;
	     % M/d, change in structural mass density
  
  %% pack dXt
  dXt = [dC dN dP dm_C dm_N dm_P dX];
