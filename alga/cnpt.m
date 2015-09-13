function [Ct, Nt , Pt, ECt, ENt, EPt, Vt] = cnpt(p, t, NP)
  %% f = cnplimb(p, t, NP)
  %% created 2003/05/22 by Bas Kooijman
  %% simultaneous C, N, P limitation in a batch-culture
  %%    maintenance costs are assummed to be negligibly small
  %% calls for dcnplim; see mydata_cnplim for an application
  
  %% p: parameter vector:
  %%    p(1)=K_C; mM, saturation constant for CO2 (C)
  %%    p(2)=K_N; mM, saturation constant for nitrate (N)
  %%    p(3)=K_P; mM, saturation constant for phosphate (P)
  %%    p(4)=j_Cm; mM/(mol*h), max spec CO2 uptake rate
  %%    p(5)=j_Nm; mM/(mol*h), max spec N 
  %%    p(6)=j_Pm; mM/(mol*h), max spec P
  %%    p(7)=k_E; 1/h, reserve turnover rate
  %%    p(8)= kap_C; -, recovery fraction for rejected C-reserves
  %%    p(9)= kap_N; -, recovery fraction for rejected N-reserves
  %%    p(10)=kap_P; -, recovery fraction for rejected P-reserves
  %%    p(11)=yC_EV; mol/mol, yield for C-reserve on structure
  %%    p(12)=yN_EV; mol/mol, yield for N-reserve on structure
  %%    p(13)=yP_EV; mol/mol, yield for P-reserve on structure
  %%    p(14)=J_C0; 1/h, transformation from B (bicarbonate) to C
  %%    p(15)=C_0; mM, initial CO2 concentration
  %%    p(16)=X_0; mM, initial structure concentration
  %%    p(17)=m_C0; mol/mol, initial C-reserve density
  %%    p(18)=m_N0; mol/mol, initial N-reserve density
  %%    p(19)=m_P0; mol/mol, initial P-reserve density
  %% t: (nt)-vector with time
  %% NP: (NP,2)-matrix with initial nitrate, phosphate concentrations
  %% f: bicarbonate

  %% State vector:
  %% Xt: C = Xt(1);  N = Xt(2);  P = Xt(3);
  %%     m_C = Xt(4); m_N = Xt(5); m_P = Xt(6); X = Xt(7);

  global K_C K_N K_P j_Cm j_Nm j_Pm k_E yC_EV yN_EV yP_EV J_C0 k_C0;
  global kap_C kap_N kap_P;
 
  %% global B C N P m_C m_N m_P X B r;

  %% unpack p
  p = p(:,1);
  K_C=p(1); K_N=p(2); K_P=p(3); j_Cm=p(4); j_Nm=p(5); j_Pm=p(6);
  k_E=p(7); kap_C=p(8); kap_N=p(9); kap_P=p(10);
  yC_EV=p(11); yN_EV=p(12); yP_EV=p(13); J_C0=p(14); J_N0=p(15);
  C_0=p(16); X_0=p(17); m_C0=p(18); m_N0=p(19); m_P0=p(20); ymMOD=p(21);
  
  m_C0 = j_Cm/k_E; m_N0 = j_Nm/k_E; m_P0 = j_Pm/k_E;
  ymMOD = 12.7/ (1 + m_C0); % conversion from OD to mM
  k_C0 = J_C0/C_0; % spec export rate of DIC from medium to air  

  [nNP k] = size(NP);

  for i = 1:nNP
    Xt0 = [C_0 NP(i,1) NP(i,2) m_C0 m_N0 m_P0 X_0];
    Xt = lsode ('dcnplim', Xt0, t);
    Ct(:,i) = Xt(:,1); Nt(:,i) = Xt(:,2); Pt(:,i) = Xt(:,3);
    ECt(:,i) = Xt(:,4).*Xt(:,7); ENt(:,i) = Xt(:,5).*Xt(:,7); 
    EPt(:,i) = Xt(:,6).*Xt(:,7); Vt(:,i) = Xt(:,7);
  end
 