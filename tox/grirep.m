function Nt = grirep(p, t, c)
  %% Nt = grirep(p, t, c)
  %% created 2002/02/18 by Bas Kooijman, modified 2009/01/15
  %% growth effects on reproduction of ectotherm: target is y_VE
  %%  yield of structure on reserve linear in internal concentration
  %%  capacity of repoduction buffer equal to zero
  %%  fast first order toxico kinetics
  %%    elimination not via reproduction
  %%  abundant food, maturity, reserve are hidden variables
  %%  zero internal conc at time zero
  %% p: 12-vector with parameters values (see below)
  %% t: (nt,1) matrix with exposure times
  %% c: (nc,1) matrix with concentrations of toxic compound
  %% Nt: (nt,nc) matrix with cumulative number of offspring

  %% application is illustrated in script-file mydata_asrep

  global C nc c0 cG kap kapR g kJ kM v Hb Hp U0

  C = c; nc = size(C,1); % copy concentrations into dummy
  
  %% unpack parameters for easy reference
  c0 = p(1);  % mM, No-Effect-Concentration (external, may be zero)
  cG = p(2);  % mM, tolerance concentration
  ke = p(3);  % 1/d, elimination rate at L = Lm
  kap = p(4); % -, fraction allocated to growth + som maint
  kapR = p(5);% -, fraction of reprod flux that is fixed into embryo reserve 
  g  = p(6);  % -, energy investment ratio
  kJ = p(7);  % 1/d, maturity maint rate coeff
  kM = p(8);  % 1/d, somatic maint rate coeff
  v  = p(9);  % cm/d, energy conductance
  Hb = p(10); % d cm^2, scaled maturity at birth
  Hp = p(11); % d cm^2, scaled maturity at puberty
  L0 = p(12); % cm, initial body length
  %% elimination rate ke at p(3) is not used
  %% it is still present for consistency with grrep

  H0 = maturity(L0, 1, [p(4:8), 0, p(9:11)]); % initial scaled maturity
  U0 = L0^3/ v; % initial reserve at max value
  %% initialize state vector; catenate to avoid loops
  X0 = [zeros(nc,1);     % N: cumulative number of offspring
        H0 * ones(nc,1); % H: scaled maturity H = M_H/ {J_EAm}
        L0 * ones(nc,1); % L: length
        U0 * ones(nc,1)]; % U: scaled reserve U = M_E/ {J_EAm}

  %% prepent zero in time vector to make sure that
  %%   initial state vector corresponds to t = 0
  t = [0;t]; nt = size(t,1);

  %% since chemical equilibrium is instantaneous U0 does not change in time
  s = max(0,(C - c0)/ cG); % stress factor
  %% since g = v [M_V]/ (\kap {J_EAm} y_VE) we have
  gs = g * (1 + s);         % stressed value for energy investment ratio
  %% since k_M = j_EM y_VE
  kMs = kM./ (1 + s);       % stressed value for maint rate coefficient
  lb = get_lb([g; kJ/ kM; Hb/ (1 - kap)], 1); Lb0 = lb * v/ kM/ g;
  U0 = 0 * s; % initiate scaled reserve of fresh egg
  for i = 1:nc
    for j = 1:50
      %%gS = g * (1 + s(i) * j/ 50); kMS = kM./ (1 + s(i) * j/ 50);
      %%lb = get_lb([gS; kJ/ kMS; Hb/ (1 - kap)], 1, lb);
    end
    %% Lb0 = lb * v/ kM/ g;
    p_U0 = [Hb/ (1 - kap); gs(i); kJ; kMs(i); v];
    [U0(i), Lb0, info] = initial_scaled_reserve(1, p_U0, Lb0);
    if info == 0 | U0(i) < 0 | Lb0 < 0
      Lb = get_lb_foetus([gs(i); kJ/ kMs(i); Hb/ (1 - kap)]) * v/ kM/ g;
      [U0(i), Lb, info] = initial_scaled_reserve(1, p_U0, Lb);
    end
    %% [p_U0; U0(i); info]
  end
  
  %% integrate changes in state
  Xt = lsode('dgrirep', X0, t);
  Nt = Xt(2:nt, 1:nc); % select cum reprod only; remove prepended zero

