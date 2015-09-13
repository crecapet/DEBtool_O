function [R, UE0, Lb, Lp, info] = reprod_rate(L, f, p, Lb0)
  %% [R, UE0, Lb, Lp, info] = reprod_rate(L, f, p, Lb0)
  %% created 2003/03/18 by Bas Kooijman, modified 2008/08/06
  %% L: n-vector with length
  %% f: scalar with functional response
  %% p: 9-vector with parameters: kap kapR g kJ kM LT v UHb UHp
  %% Lb0: optional scalar with length at birth (initial value only)
  %%     or optional 2-vector with length, L, and scaled maturity, UH < UHp
  %%     for a juvenile that is now exposed to f, but previously at another f
  %% R: n-vector with reproduction rates
  %% UE0: scalar with scaled initial reserve
  %% Lb: scalar with (volumetric) length at birth
  %% Lp: scalar with (volumetric) length at puberty
  %% info: indicator for failure (0) or success (1)
  %% see also cum_reprod

  %% standard DEB model in energies, lengths, time
  %% 
  %% R = kapR * pR/ E0
  %% pR = (1 - kap) pC - kJ * EHp
  %% [pC] = [Em] (v/ L + kM (1 + LT/L)) f g/ (f + g); pC = [pC] L^3
  %% [Em] = {pAm}/ v
  %%
  %% remove energies; now in lengths, time only
  %%
  %% U0 = E0/{pAm}; UHp = EHp/{pAm}; SC = pC/{pAm}; SR = pR/{pAm}
  %% R = kapR SR/ U0
  %% SR = (1 - kap) SC - kJ * UHp
  %% SC = f (g/ L + (1 + LT/L)/ Lm)/ (f + g); Lm = v/ (kM g)

  %% unpack parameters; parameter sequence, cf get_pars_r
  kap = p(1); kapR = p(2); g = p(3); kJ = p(4); kM = p(5);
  LT = p(6); v = p(7); UHb = p(8); UHp = p(9);

  Lm = v/ (kM * g); % maximum length
  VHb = UHb/ (1 - kap); VHp = UHp/ (1 - kap);
  vHb = VHb * g^2 * kM^3/ v^2; vHp = VHp * g^2 * kM^3/ v^2; 

  if exist('Lb0','var') == 0
    lb0 = [];
  elseif length(Lb0) ~= 2
    lb0 = Lb0/ Lm; % scaled length at birth
  else % lb0 = [l vH] at time = 0
    lb0 = [Lb0(1)/ Lm; Lb0(2) * g^2 * kM^3/ v^2/ (1 - kap)];
  end

  p_lp = [g; kJ/ kM; LT/ Lm; vHb; vHp]; % pars for get_lp
  [lp, lb, info] = get_lp(p_lp, f, lb0);
  Lb = lb * Lm; Lp = lp * Lm; % volumetric length at birth, puberty

  if info == 0 % return at failure for lp
    R = L * 0; UE0 = [];
    return;
  end

  p_UE0 = [VHb; g; kJ; kM; v]; % pars for initial_scaled_reserve  
  [UE0 Lb info] = initial_scaled_reserve(f, p_UE0, Lb);

  SC = f * L.^3 .* (g ./ L + (1 + LT ./ L)/ Lm)/ (f + g);
  SR = (1 - kap) * SC - kJ * UHp;
  R = (L >= Lp) * kapR .* SR/ UE0; % set reprod rate of juveniles to zero