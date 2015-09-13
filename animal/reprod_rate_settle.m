function [R, UE0, info] = reprod_rate_settle(L, f, p)
  %% [R, UE0, info] = reprod_rate_settle(L, f, p)
  %% created 2011/07/21 by Bas Kooijman
  %% reproduction rate if isomorphic juveniles are V1-morphs between s and j
  %% L: n-vector with length
  %% f: scalar with functional response
  %% p: 13-vector with parameters: kap kapR g kJ kM LT v UHb UHp Lb Ls Lj Lp
  %%  g and v refer to the values for embryo
  %%  scaling is always with respect to embryo values
  %% R: n-vector with reproduction rates
  %% UE0: scalar with scaled initial reserve
  %% info: indicator for failure (0) or success (1)

  %% standard DEB model in energies, lengths, time
  %% V1-morphic juvenile between stages s and j with E_Hb>E_Hs>E_Hj>E_Hp
  %% theory is given in comments to DEB3 section 7.8.2

  %% R = kapR * pR/ E0
  %% pR = (1 - kap) pC - kJ * EHp
  %% [pC] = [Em] (v/ L + kM (1 + LT/ L)) f g/ (f + g); pC = [pC] L^3
  %% [Em] = {pAm}/ v
  %%
  %% remove energies; now in lengths, time only
  %%
  %% U0 = E0/{pAm}; UHp = EHp/{pAm}; SC = pC/{pAm}; SR = pR/{pAm}
  %% R = kapR SR/ U0
  %% SR = (1 - kap) SC - kJ * UHp
  %% SC = f (g/ L + (1 + LT/L)/ Lm)/ (f + g); Lm = v/ (kM g)

  %% unpack parameters; parameter sequence, cf get_pars_r
  kap = p(1); kapR = p(2); g = p(3)  ; kJ = p(4) ; 
  kM = p(5);  LT =  p(6); v = p(7)   ; UHb = p(8);
  UHp = p(9); Lb = p(10); Ls = p(11); Lj = p(12) ; Lp = p(13);

  Lm = v/ (kM * g); % maximum length
  VHb = UHb/ (1 - kap);
 
  p_UE0 = [VHb; g; kJ; kM; v]; % pars for initial_scaled_reserve  
  [UE0 Lb info] = initial_scaled_reserve(f, p_UE0, Lb);

  SC = L .^ 2 .* ((g + LT/ Lm) * Lj/ Ls + L/ Lm)/ (1 + g/ f);
  SR = (1 - kap) * SC - kJ * UHp;
  R = (L >= Lp) * kapR .* SR/ UE0; % set reprod rate of juveniles to zero