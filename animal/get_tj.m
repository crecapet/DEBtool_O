function [tj tp tb lj lp lb li rj rB info] = get_tj(p, f, lb0)
  %  [tj tp tb lj lp lb li rj rB info] = get_tj(p, f, lb0)
  %  created at 2011/04/25 by Bas Kooijman, modified 2011/07/22
  %  notice j-p-b sequence in output, due to the name of the routine
  %  p: 6-vector with parameters: g, k, l_T, v_H^b, v_H^j v_H^p 
  %     if 5-vector outpus tp and lp are empty
  %  f: optional scalar with functional response (default f = 1)
  %  lb0: optional scalar with scaled length at birth
  %      or optional 2-vector with scaled length, l, and scaled maturity, vH
  %      for a juvenile that is now exposed to f, but previously at another f
  %  tj: scaled with age at metamorphosis \tau_j = a_j k_M
  %      if length(lb0)==2, tj is the scaled time till metamorphosis
  %  tp: scaled with age at puberty \tau_p = a_p k_M
  %      if length(lb0)==2, tp is the scaled time till puberty
  %  tb: scaled with age at birth \tau_b = a_b k_M
  %  lj: scaled length at metamorphosis
  %  lp: scaled length at puberty
  %  lb: scaled length at birth
  %  li: ultimate scaled length
  %  rj: scaled exponential growth rate between b and j
  %  rB: scaled von Bertalanffy growth rate between j and i
  %  info: indicator equals 1 if successful
  
  n_p = length(p);
  
  %% unpack pars
  g   = p(1); % energy investment ratio
  k   = p(2); % k_J/ k_M, ratio of maturity and somatic maintenance rate coeff
  lT  = p(3); % scaled heating length {p_T}/[p_M]Lm
  vHb = p(4); % v_H^b = U_H^b g^2 kM^3/ (1 - kap) v^2; U_B^b = M_H^b/ {J_EAm}
  vHj = p(5); % v_H^j = U_H^j g^2 kM^3/ (1 - kap) v^2; U_B^j = M_H^j/ {J_EAm}
  if n_p > 5
    vHp = p(6); % v_H^p = U_H^p g^2 kM^3/ (1 - kap) v^2; U_B^p = M_H^p/ {J_EAm}
  else
    vHp = 0;
  end
  
  if exist('f','var') == 0
    f = 1;
  elseif isempty(f)
    f = 1;
  end
  if exist('lb0','var') == 0
    lb0 = [];
  end

  if k == 1 && f * (f - lT)^2 > vHp * k % constant maturity density, reprod possible
    lb = vHb^(1/3);                  % scaled length at birth
    tb = get_tb(p([1 2 4]), f, lb);  % scaled age at birth
    lj = vHj^(1/3);                  % scaled length at metamorphosis
    rj = g * (f/ lb - 1 - lT/ lb)/ (f + g); % scaled exponential growth rate between b and j
    tj = tb + (log(lj/ lb)) * 3/ rj; % scaled age at metamorphosis
    lp = vHp^(1/3);                  % scaled length at puberty
    li = f * lj/ lb - lT;            % scaled ultimate length
    rB = 1/ 3/ (1 + f/ g);           % scaled von Bert growth rate between j and i
    tp = tj + (log ((li - lj)/ (li - lp)))/ rB; % scaled age at puberty
    info = 1;
    return
  elseif k == 1 && f * (f - lT)^2 > vHj * k % constant maturity density, metam possible
    lb = vHb^(1/3);                  % scaled length at birth
    tb = get_tb(p([1 2 4]), f, lb);  % scaled age at birth
    lj = vHj^(1/3);                  % scaled length at metamorphosis
    rj = g * (f/ lb - 1 - lT/ lb)/ (f + g); % scaled exponential growth rate between b and j
    tj = tb + (log(lj/ lb)) * 3/ rj; % scaled age at metamorphosis
    lp = vHp^(1/3);                  % scaled length at puberty
    li = f * lj/ lb - lT;            % scaled ultimate length
    rB = 1/ 3/ (1 + f/ g);           % scaled von Bert growth rate between j and i
    tp = 1e20;                       % scaled age at puberty
    info = 1;
    return
  end
  
  [tb lb info_tb] = get_tb (p([1 2 4]), f, lb0); 
  [lj lp lb info_tj] = get_lj(p, f, lb);
  rj = g * (f/ lb - 1 - lT/ lb)/ (f + g); % scaled exponential growth rate between b and j
  tj = tb + (log(lj/ lb)) * 3/ rj;   % scaled age at metamorphosis
  rB = 1/ 3/ (1 + f/ g);             % scaled von Bert growth rate between j and i
  li = f * lj/ lb - lT;              % scaled ultimate length

  if isempty(lp) % length(p) < 6
    tp = [];
  elseif  li <=  lp                  % reproduction is not possible
    tp = 1e20;                       % tau_p is never reached
    lp = 1;                          % lp is nerver reached
  else % reproduction is possible
    if length(lb0) ~= 2 % lb0 is absent, empty or a scalar
      tp = tj + log((li - lj)/ (li - lp))/ rB;
    else % lb0 = l and t for a juvenile
      tb = NaN;
      l = lb0(1);
      tp = irB * log((li - l)/ (li - lp));
    end
  end
  
  if isempty(tp)
    info = info_tb;
    return
  end
  
  info = min(info_tb, info_tj);
  if isreal(tp) == 0 || isreal(tj) == 0 % tj and tp must be real and positive
    info = 0;
  elseif tp < 0 || tj < 0
    info = 0;
  end
  
