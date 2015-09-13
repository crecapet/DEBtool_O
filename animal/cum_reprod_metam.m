function [N, UE0, Lb, Lj, Lp, ab, aj, ap, info] = cum_reprod_metam(a, F, p, Lb0)
  %% [N, UE0, Lb, Lj, Lp, ab, aj, ap, info] = cum_reprod_metam(a, F, p, Lb0)
  %% created 2011/06/16 by Bas Kooijman, modidied 2012/08/28 by Starrlight Augustine
  %% a: n-vector with time since birth or since start if Lb0 has length 2
  %% F: scalar with functional response
  %% p: 9-vector with parameters (see below)
  %% Lb0: optional scalar with length at birth (initial value only)
  %% N: n-vector with cumulative reproduction
  %% UE0; scalar with initial scaled reserve
  %% Lb: scalar with length at birth
  %% Lj: scalar with length at metamorphosis
  %% Lp: scalar with length at puberty
  %% ab: age at puberty at birth
  %% aj: age at puberty at metamorphosis
  %% ap: time at puberty since birth or time till puberty if Lb0 has length 2
  %% info: indicator for failure (0) of success (1)
  %% see also reprod_rate_metam

  global f g kap kJ UHp LB LP LM LT rB sM % transfer to fncum_rep

  %% unpack parameters; parameter sequence, cf reprod_rate_metam
  kap = p(1); kapR = p(2);  g = p(3);  kJ = p(4) ; 
   kM = p(5);   LT = p(6);  v = p(7); UHb = p(8);
  UHj = p(9);  UHp = p(10);

  %% compound parameters and par-vector
  f = F; % copy f for transfer to fncum_reprod
  Lm = v/ (kM * g); % max length
  VHb = UHb/ (1 - kap); VHj = UHj/ (1 - kap); VHp = UHp/ (1 - kap);
  vHb = VHb * g^2 * kM^3/ v^2; vHj = VHj * g^2 * kM^3/ v^2; vHp = VHp * g^2 * kM^3/ v^2; 
  p_tj = [g; kJ/ kM; LT/ Lm; vHb; vHj; vHp];   % pars for get_tj
  p_UE0 = [VHb; g; kJ; kM; v]; % pars for initial_scaled_reserve  

  if exist('Lb0','var') == 0
    lb0 = [];
  else
    lb0 = Lb0/ Lm; % scaled length at birth
  end
 
  [tj tp tb lj lp lb li rhoj rhoB info] = get_tj(p_tj, f, lb0);
  ab = tb/ kM;  aj = tj/ kM; ap = tp/ kM; rB = kM * rhoB;
  Lb = lb * Lm; Lj = lj * Lm; Lp = lp * Lm; % volumetric length at birth, puberty
  if info ~= 1 % return at failure for tp
    fprintf('tp could not be obtained in cum_reprod_metam \n')
    N = a(:,1) * 0; UE0 = [];
    return;
  end

  LB = Lj; % length at metamorphosis for use in fncum_reprod
  LP = Lp; % length at puberty for use in fncum_reprod
  LM = Lm; % max length for use in fncum_reprod
  sM = lj/ lb; % stress value for acceleration
 
  a0 = 0; na = length(a); % number of time points
  Ui = 0; U = 0 * a; % initialise U: scaled reserve allocated to reprod
  for i = 1:na
    if a(i) + ab < aj
      Ui = 0;
    else
      Ui = Ui + quad('fncum_reprod', a0 + ab - aj, a(i) + ab - aj); a0 = a(i);
    end
    U(i) = Ui;
  end
    
  [UE0 Lb info] = initial_scaled_reserve(f, p_UE0, Lb);
  if info ~= 1 % return at failure for tp
    fprintf('UE0 could not be obtained in cum_reprod_metam \n')
  end
  N = max(0, kapR * U/ UE0); % convert to number of eggs
  