function [H info] = maturity(L, F, p)
  %% H = maturity(L, F, p)
  %% Bas Kooijman, 2006/09/29, modified 2011/07/20
  %% L: n-vector with length 
  %% p: 9-vector with parameters (see below)
  %% F: scalar with (constant) scaled functional response
  %% H: n-vector with scaled maturities: H = M_H/ {J_EAm}
  %% info: scalar for success (1) or failre (0)

  %% routine called by debtool/tox/*rep

  global f g kap lT k uHb uHp

  kap = p(1); % -, fraction allocated to growth + som maint
  %kapR = p(2);% -, fraction of reprod flux that is fixed in embryo reserve 
  g  = p(3);  % -, energy investment ratio
  kJ = p(4);  % 1/d, maturity maint rate coeff
  kM = p(5);  % 1/d, somatic maint rate coeff
  LT = p(6);  % cm, heating length
  v  = p(7);  % cm/d, energy conductance
  Hb = p(8); % d cm^2, scaled maturity at birth
  Hp = p(9); % d cm^2, scaled maturity at puberty
  %% kapR is not used, but kept for consistency with iget_pars_r, reprod_rate

  if exist('F','var') == 0
    f = 1; % abundant food
  else
    f = F; % to make scaled functional response global
  end

  Lm = v/ kM/ g; lT = LT/ Lm; k = kJ/ kM;
  
  uHb = Hb * g^2 * kM^3/ (v^2); vHb = uHb/ (1 - kap);
  uHp = Hp * g^2 * kM^3/ (v^2); vHp = uHp/ (1 - kap);
  [lp lb info] = get_lp([g; k; lT; vHb; vHp], f);
  Lp = Lm * lp;
  
  sel_adult = (L >= Lp);
  L_j = max(L(~sel_adult)); L_a = L(sel_adult);
  n_j = length(L_j); n_a = length(L_a);
  H = 0 * L; % initiate H
  
  if n_j > 0     
    ue0 = get_ue0([g, 1], f, lb); %% initial scaled reserve M_E^0/{J_EAm}
    teh = lsode('dget_teh',  [0; ue0; 0], [1e-6; L_j]/ Lm);
    teh(1,:) = [];
    if n_j == 1
       H(~sel_adult) = teh(end,3) * v^2/ g^2/ kM^3;
    else
       H(~sel_adult) = teh(:,3) * v^2/ g^2/ kM^3;
    end
  end
  if n_a > 0
    H(sel_adult) = Hp;
  end