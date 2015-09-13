function data = iget_pars_9 (par)
% [Edata] = iget_pars_9 (par, data)
% from DEB parameters to zero-variate data
% assumptions:
%   abundant food (f=1)
%   a_b, a_p, a_m and R_m are temp-corrected to T_ref = 293 K
    p_T = 0;       % J/d.cm^2, {p_T}, surface-spec som maint cost
    kap_R = 0.95;  % -, reproduction efficiency
%   kap_G = 0.8;   % -, growth efficiency (included in [E_G] - d_V relationship)
    k_J = 0.002;   % 1/d, maturity maint rate coeff
    mu_V = 5E5;    % J/C-mol, chemical potential for structure
    mu_E = 5.5E5;  % J/C-mol, chemical potential for reserve
    w_V = 23.9;    % g/C-mol, molecular weight for structure: C:H:O:N = 1:1.8:0.5:0.15
    w_E = 23.9;    % g/C-mol, molecular weight for reserve:   C:H:O:N = 1:1.8:0.5:0.15
    s_G = 1e-4;    % -, Gompertz stress coefficient
%
% par: see below
% data: 
%  d_V = dat(1); % g/cm^3,  specific density of structure 
%  a_b = dat(2); % d, age at birth
%  a_p = dat(3); % d, age at puberty
%  a_m = dat(4); % d, age at death due to ageing
%  W_b = dat(5); % g, wet weight at birth
%  W_j = dat(6); % g, wet weight at metamorphosis
%  W_p = dat(7); % g, wet weight at puberty
%  W_m = dat(8); % g, maximum wet weight
%  R_m = dat(9); % #/d, maximum reproduction rate

  % unpack par
  p_Am = par(1); % J/d.cm^2, {p_Am}, max specific assimilation rate 
  v    = par(2); % cm/d, energy conductance
  kap  = par(3); % -, allocation fraction to soma
  p_M  = par(4); % J/d.cm^3, [p_M], specific somatic maintenance costs
  E_G  = par(5); % J/cm^3, [E_G], specific cost for structure  
  E_Hb = par(6); % J, E_H^b, maturity level at birth 
  E_Hj = par(7); % J, E_H^j, maturity level at metamorphosis
  E_Hp = par(8); % J, E_H^p, maturity level at puberty
  h_a  = par(9); % 1/d^2, ageing acceleration

  % compound pars
  k_M = p_M/ E_G;                  % 1/d, somatic maintenance rate coefficient
  k = k_J/ k_M;                    % -, maintenance ratio

  d_V = E_G/ 2.6151e4;             % g/cm^3, specific density of structure 
  E_m = p_Am/ v;                   % J/cm^3, [E_m] reserve capacity 
  g = E_G/ kap/ E_m;               % -, energy investment ratio
  w = E_m * w_E/ d_V/ mu_E;        % -, contribution of reserve to weight

  L_m = v/ k_M/ g;                 % cm, maximum structural length
  L_T = p_T/ p_M;                  % cm, heating length (also applies to osmotic work)
  l_T = L_T/ L_m;                  % -, scaled heating length

  % maturity at birth
  U_Hb = E_Hb/ p_Am;               % cm^2 d, scaled maturity at birth
  V_Hb = U_Hb/ (1 - kap);          % cm^2 d, scaled maturity at birth
  v_Hb = V_Hb * g^2 * k_M^3/ v^2;  % -, scaled maturity at birth
  % maturity at metamorphosis
  U_Hj = E_Hj/ p_Am;               % cm^2 d, scaled maturity at metamorphosis
  V_Hj = U_Hj/ (1 - kap);          % cm^2 d, scaled maturity at metamorphosis
  v_Hj = V_Hj * g^2 * k_M^3/ v^2;  % -, scaled maturity at metamorphosis
  % maturity at puberty
  U_Hp = E_Hp/ p_Am;               % cm^2 d, scaled maturity at puberty 
  V_Hp = U_Hp/ (1 - kap);          % cm^2 d, scaled maturity at puberty
  v_Hp = V_Hp * g^2 * k_M^3/ v^2;  % -, scaled maturity at puberty

  % obtain predictions

  pars_tj = [g; k; l_T; v_Hb; v_Hj; v_Hp]; % compose parameter vector for get_tj
  [t_j t_p t_b l_j l_p l_b l_i] = get_tj(pars_tj, 1);

  a_b = t_b/ k_M;  % d, age at birth
% a_j = t_j/ k_M  % d, age at metamorphosis
  a_p = t_p/ k_M;  % d, age at puberty

  L_b = l_b * L_m; % cm, structural length at birth
  L_j = l_j * L_m; % cm, structural length at metamorphosis
  L_p = l_p * L_m; % cm, structural length at puberty
  L_i = l_i * L_m; % cm, ultimate structural length

  Ww_b = L_b^3 * (1 + w); % g, wet weight at birth
  Ww_j = L_j^3 * (1 + w); % g, wet weight at metamorphosis
  Ww_p = L_p^3 * (1 + w); % g, wet weight at puberty
  Ww_m = L_i^3 * (1 + w); % g, ultimate wet weight

  pars_Rm = [kap; kap_R; g; k_J; k_M; L_T; v; U_Hb; U_Hp; L_b; L_j; L_p]; % compse par vector
  R_m = reprod_rate_metam(L_i, 1, pars_Rm); % #/d, maximum reprod rate

  pars_tm = [g; l_T; h_a/ k_M^2; s_G];     % compose parameter vector
  t_m = get_tm_s(pars_tm, 1);              % -, scaled mean life span
  a_m = t_m/ k_M;                          % d, mean life span at T

  % pack data
  data = [d_V; a_b; a_p; a_m; Ww_b; Ww_j; Ww_p; Ww_m; R_m];
