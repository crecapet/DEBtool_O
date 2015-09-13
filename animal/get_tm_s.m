function [tm Sb Sp info] = get_tm_s(p, f, lb, lp)
  %% [tm Sb Sp info] = get_tm_s(p, f, lb, lp)
  %% created 2009/02/21 by Bas Kooijman, modified 2010/04/13
  %% calculates scaled mean life span at constant f for short growth periods
  %% theory: see comments on DEB3 Section 6.1.1 
  %% p: 4 or 7-vector with parameters: [g lT ha sG] or [g k lT vHb vHp ha SG]
  %% f: optional scalar with scaled functional response; default: f = 1
  %% lb: optional scalar with scaled length at birth
  %% lp: optional scalar with scaled length at puberty
  %% tm: scalar with scaled mean life span
  %% Sb: scalar with survival probability at birth
  %% Sp: scalar with survival prabability at puberty
  %% info: scalar with indicator for succes (1) or failure (0)
 
  global tG

  if exist('f','var') == 0
    f = 1;
  elseif isempty(f)
    f = 1;
  end

  if length(p) >= 7
    %% unpack pars
    g   = p(1); % energy investment ratio
    %k   = p(2); % k_J/ k_M, ratio of maturity and somatic maintenance rate coeff
    lT  = p(3); % scaled heating length {p_T}/[p_M]Lm
    %vHb = p(4); % v_H^b = U_H^b g^2 kM^3/ (1 - kap) v^2; U_B^b = M_H^b/ {J_EAm}
    %vHp = p(5); % v_H^p = U_H^p g^2 kM^3/ (1 - kap) v^2; U_B^p = M_H^p/ {J_EAm}
    ha  = p(6); % h_a/ k_M^2, scaled Weibull aging acceleration
    sG  = p(7); % Gompertz stress coefficient
    
  elseif length(p) == 4
    %% unpack pars
    g   = p(1); % energy investment ratio
    lT  = p(2); % scaled heating length {p_T}/[p_M]Lm
    ha  = p(3); % h_a/ k_M^2, scaled Weibull aging acceleration
    sG  = p(4); % Gompertz stress coefficient
  end

  if abs(sG) < 1e-10
    sG = 1e-10;
  end
  
  li = f - lT;
  hW3 = ha * f * g/ 6/ li; hW = hW3^(1/3); % scaled Weibull aging rate
  hG = sG * f * g * li^2;  hG3 = hG^3;     % scaled Gompertz aging rate
  tG = hG/ hW; tG3 = hG3/ hW3;             % scaled Gompertz aging rate

  if length(p) >= 7
    if exist('lp','var') == 0 && exist('lb','var') == 0 
      [lp lb info_lp] = get_lp (p, f);
    elseif exist('l_p','var') == 0 || isempty('l_p')
      [lp lb info_lp] = get_lp(p, f, lb);
    end

    % get scaled age at birth, puberty: tb, tp
    [tb lb info_tb] = get_tb(p, f, lb);
    irB = 3 * (1 + f/ g);
    tp = tb + irB * log((li - lb)/ (li - lp));
    hGtb = hG * tb;
    Sb = exp((1 - exp(hGtb) + hGtb + hGtb^2/ 2) * 6/ tG3); 
    hGtp = hG * tp;
    Sp = exp((1 - exp(hGtp) + hGtp + hGtp^2/ 2) * 6/ tG3); 
    if info_lp == 1 && info_tb == 1
      info = 1;
    else
      info = 0;
    end
  else % length(p) == 4
    Sb = NaN; Sp = NaN; info = 1;
  end
  
  if abs(sG) < 1e-4
    tm = gamma(4/3)/ hW;
    tm_tail = 0;
  elseif hG > 0
    tm = 10/ hG; % upper boundary for main integration of S(t)
    tm_tail = expint(exp(tm * hG) * 6/ tG3)/ hG;
    tm = quadl('fnget_tm_s', 0, tm * hW)/ hW + tm_tail;
  else % hG < 0
    tm = -1e4/ hG; % upper boundary for main integration of S(t)
    hw = hW * sqrt( - 3/ tG); % scaled hW
    tm_tail = sqrt(pi)* erfc(tm * hw)/ 2/ hw;
    tm = quadl('fnget_tm_s', 0, tm * hW)/ hW + tm_tail;
  end