function [LOO, teLLOO] = f2o (tcf, eb, LOb, par)
  %% [LOO, teLLLO] = f2o (tcf, eb, Lb, LOb, tm)
  %% created by Bas Kooijman, 2007/08/29
  %% from scaled func response f to opacity O
  %% tcf: (n,3)-matrix with time t, tmep cor factor c_T, func resp f
  %% eb: scalar with e at t=0
  %% LOb: scalar with otolith length LO at t=0 (birth)
  %% par: 10-vector with parameters, see below
  %% LOO: (n,2)-matrix with L_O, O
  %% teLLOO: (n,5)-matrix with time, e, L, LO, O

  global tc tf
  global Lp Lm v vOD vOG g kap kapR delS

  tc = tcf(:,[1 2]); tf = tcf(:,[1 3]); n = size(tcf,1);

  %% unpack par
  Lb = par(1); % cm, length at birth
  Lp = par(2); % cm, length at puberty
  v = par(3);  % cm/d, energy conductance
  vOD = par(4); % mum/d, otolith growth linked to dissipation
  vOG = par(5); % mum/d, otolith growth linked to body growth
  kM = par(6); % 1/d, maintenance rate coefficient 
  g = par(7);  % -, energy investment ratio
  kap = par(8); % -, fraction to som maint + growth
  kapR = par(9); % -, reproduction efficiency
  delS = par(10); % -, shape coefficient for otosac

  Lm = v/ kM/ g;

  eLLO = lsode('df2o_ello', [eb, Lb, LOb], tcf(:,1));

  teLLOO = [tcf(:,1), eLLO(:,[1 2 3])];
  E = eLLO(:,1); L = eLLO(:,2); LO = eLLO(:,3); cor_T = tcf(:,2); f = tcf(:,3);
  E_0 = E(n); L_0 = L(n); LO_0 = LO(n); f_0 = f(n); 
  c_0 = tc(n,2); vT_0 = c_0 * v;
  %% 1/d, change in scaled res density e = m_E/ m_Em
  dE_0 = vT_0 * ((L_0 > Lb) * f_0 - E_0) / L_0; 
 
  SC = cor_T .* L .^ 2 .* (g + L/ Lm) .* E ./ (g + E); % p_C/ {p_Am}
  SM = cor_T * kap .* L .^ 3/ Lm; % p_M/ {p_Am}
  SG = max(0,kap * SC - SM); % p_G/ {p_Am}
  SD = (SM + (1 - (L > Lp) * kapR) * (1 - kap) .* SG)/ kap; % p_D/ {p_Am}
  
  svS = vOD * SD + vOG * SG;
  vSG = vOG * SG;
  O = vSG ./ svS; % opacity
  teLLOO = [tcf(:,1), eLLO, O];

  LOO = [LO, O];