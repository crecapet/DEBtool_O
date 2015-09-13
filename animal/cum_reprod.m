function [N, UE0, Lb, Lp, ab, ap, info] = cum_reprod(a, F, p, Lb0)
  %% [N, UE0, Lb, Lp, ab, ap, info] = cum_reprod(a, f, p, Lb0)
  %% created 2008/08/06 by Bas Kooijman, modified 2012/08/28
  %% a: n-vector with time since birth or since start if Lb0 has length 2
  %% F: scalar with functional response
  %% p: 9-vector with parameters (see below)
  %% Lb0: optional scalar with length at birth (initial value only)
  %%     or optional 2-vector with length, L, and scaled maturity, UH < UHp
  %%     for a juvenile that is now exposed to f, but previously at another f
  %% N: n-vector with cumulative reproduction
  %% UE0; scalar with initial scaled reserve
  %% Lb: scalar with length at birth
  %% Lp: scalar with length at puberty
  %% ab: age at puberty at birth
  %% ap: time at puberty since birth or time till puberty if Lb0 has length 2
  %% info: indicator for failure (0) of success (1)
  %% see also reprod_rate

  global f g kap kJ UHp LB LP LM LT rB sM % transfer to fncum_rep

  %% unpack parameters; parameter sequence, cf get_pars_r
  kap = p(1); kapR = p(2); g = p(3);   kJ = p(4);  kM = p(5);
  LT = p(6);  v = p(7);    UHb = p(8); UHp = p(9); f = F;

  %% compound parameters and par-vector
  Lm = v/ (kM * g); % max length
  rB = kM/ (1 + f/ g)/ 3; % von Bert growth rate
  VHb = UHb/ (1 - kap);        VHp = UHp/ (1 - kap);
  vHb = VHb * g^2 * kM^3/ v^2; vHp = VHp * g^2 * kM^3/ v^2; 
  p_lp = [g; kJ/ kM; LT/ Lm; vHb; vHp];   % pars for get_tp
  p_UE0 = [VHb; g; kJ; kM; v]; % pars for initial_scaled_reserve  

  if exist('Lb0','var') == 0
    lb0 = [];
  elseif length(Lb0) ~= 2
    lb0 = Lb0/ Lm; % scaled length at birth
  else % lb0 = [l vH] at time = 0
    lb0 = [Lb0(1)/ Lm; Lb0(2) * g^2 * kM^3/ v^2/ (1 - kap)];
  end
 
  [tp tb lp lb info] = get_tp(p_lp, f, lb0);
  ap = tp/ kM; ab = tb/ kM; 
  Lb = lb * Lm; Lp = lp * Lm; % volumetric length at birth, puberty
  LP = Lp; % copy for use in fncum_reprod
  if info ~= 1 % return at failure for tp
    fprintf('tp could not be obtained in cum_reprod \n')
    N = a(:,1) * 0; UE0 = [];
    return;
  end

  if length(lb0) ~= 2 % Lb0 = initial estimate for Lb only
    ap = ap - ab; % time since birth
    LB = Lb; LM = Lm; sM = 1; % length at birth & max length for use in fncum_reprod
  else % Lb0 = [L UH] at time = 0
    LB = Lb0(1); % length at time = 0 for use in fncum_reprod
  end
 
  a0 = 0; na = length(a); % number of time points
  Ui = 0; U = 0 * a; % initialise U: scaled reserve allocated to reprod
  for i = 1:na
    if a(i) < ap
      Ui = 0;
    elseif a0 < ap
      a0 = ap;
      Ui = Ui + quad('fncum_reprod', a0, a(i)); a0 = a(i);
    else
      Ui = Ui + quad('fncum_reprod', a0, a(i)); a0 = a(i);
    end
    U(i) = Ui;
  end
    
  [UE0 Lb info] = initial_scaled_reserve(f, p_UE0, Lb);
  if info ~= 1 % return at failure for tp
    fprintf('UE0 could not be obtained in cum_reprod \n')
  end
  N = max(0, kapR * U/ UE0); % convert to number of eggs  