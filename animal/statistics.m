%% created 2000/11/02 by Bas Kooijman, modified 2011/09/14
% calculates food-dependent quantities for 'animal'
% run pars_animal before running this script
% add_my_pet is also using this script; first run pars_my_pet 

%% life stage quantities

pars_E0 = [V_Hb; g; kT_J; kT_M; vT]; % pars for initial_scaled_reserve
if foetus == 1 % foetal development, no metamorphosis  
  % notice that foetal development typically combines with high U_Hb
  [U_E0 L_b info] = initial_scaled_reserve_foetus(f, pars_E0); % d cm^2, initial scaled reserve
  if info ~= 1
    fprintf('warning in initial_scaled_reserve_foetus: invalid parameter value combination for foetus \n')
  end
  [l_b, t_b, info] = get_lb_foetus([g; k; v_Hb]);
  if info ~= 1
    fprintf('warning in get_lb_foetus: invalid parameter value combination for foetus \n')
  end
  l_j = l_b;
  t_j = t_b;
  pars_tp = [g; k; l_T; v_Hb; v_Hp]; % parameters for get_tp_foetus
  [t_p tb l_p lb info] = get_tp_foetus(pars_tp, f, l_b);
  if info ~= 1
    fprintf('warning in get_tp: invalid parameter value combination for foetus \n')
  end
  l_i = f - l_T;                       % scaled ultimate length
  r_B = 1/(3/ kT_M + 3 * f * L_m/ vT); % 1/d, von Bert growth rate after j
  clear tb lb
else % egg development, possibly with metamorphosis
  [U_E0 L_b info] = initial_scaled_reserve(f, pars_E0); % d cm^2, initial scaled reserve
  l_b = L_b/ L_m;                      % scaled length at birth
  if info ~= 1
    fprintf('warning in initial_scaled_reserve: invalid parameter value combination for egg \n')
  end
  if E_Hj == E_Hb % no metamorphosis
    pars_tp = [g; k; l_T; v_Hb; v_Hp]; % parameters for get_tp
    [t_p t_b l_p l_b info] = get_tp(pars_tp, f, l_b); % -, scaled age at puberty
    if info ~= 1              
      fprintf('warning in get_tp: invalid parameter value combination for t_p \n')
    end
    l_j = l_b;                          % -, scaled length at metamorphosis
    t_j = t_b;                          % -, scaled age at metamorphosis
    l_i = f - l_T;                      % -, scaled ultimate length
    r_j = 0;                            % 1/d, exponential growth rate between b and j
    r_B = 1/(3/ kT_M + 3 * f * L_m/ vT);% 1/d, von Bert growth rate after j
  else % metamorphosis
    % notice that L_m relates to the embryo-values
    pars_tj = [g; k; l_T; v_Hb; v_Hj; v_Hp]; % parameters for get_tj
    [t_j t_p t_b l_j l_p l_b l_i rho_j rho_B info] = get_tj(pars_tj, f, l_b); 
    if info ~= 1
      fprintf('warning in get_tj: invalid parameter value combination for t_j \n')
    end
    r_j = rho_j * kT_M;  % 1/d, exponential growth rate between b and j
    r_B = rho_B * kT_M;  % 1/d, von Bert growth rate after j
  end
end
E_0 = pT_Am * U_E0;    % J, initial reserve (of embryo)
M_E0 = E_0/ mu_E;      % mol, initial reserve (of embryo)
W_0 = M_E0 * w_O(3);   % g, initial reserve (of embryo)
    
a_b = t_b/ kT_M;       % d, age at birth at T
a_j = t_j/ kT_M;       % d, age at metamorphosis at T
a_p = t_p/ kT_M;       % d, age at puberty at T
a_99 = a_p + log((1 - l_p/ l_i)/(1 - 0.99))/ r_B; 
				       % d, time to reach length 0.99 * L_i
L_b = L_m * l_b;       % cm, structural length at birth
L_j = L_m * l_j;       % cm, structural length at metamorphosis
L_p = L_m * l_p;       % cm, structural length at puberty
L_i = L_m * l_i;       % cm, ultimate structural length
Lw_b = L_b/ del_M;     % cm. physical length at birth
Lw_j = L_j/ del_M;     % cm. physical length at metamorphosis
Lw_p = L_p/ del_M;     % cm, physical length at puberty
Lw_i = L_i/ del_M;     % cm, physical ultimate length
M_Vb = M_V * L_b^3;    % mol, structural mass at birth
M_Vj = M_V * L_j^3;    % mol, structural mass at metamorphosis
M_Vp = M_V * L_p^3;    % mol, structural mass at puberty
M_Vi = M_V * L_i^3;    % mol, ultimate structural mass
U_Eb = f * E_m * L_b^3/ pT_Am; % d cm^2, scaled reserve at birth
del_Ub = U_Eb/ U_E0;   % -, fraction of reserve left at birth
s_M = L_j/ L_b;        % -, acceleration factor

%% size

W_b = L_b^3 * d_O(2) * (1 + f * m_Em * w_O(3)/ w_O(2)); % g, dry weight at birth
W_j = L_j^3 * d_O(2) * (1 + f * m_Em * w_O(3)/ w_O(2)); % g, dry weight at metamorphosis
W_p = L_p^3 * d_O(2) * (1 + f * m_Em * w_O(3)/ w_O(2)); % g, dry weight at puberty
W_i = L_i^3 * d_O(2)* (1 + f * m_Em * w_O(3)/ w_O(2)); % g, ultimate dry weight

del_Wb = W_b/ W_m;     % -, birth weight as fraction of maximum weight
del_Wj = W_j/ W_m;     % -, metamorphosis weight as fraction of maximum weight
del_Wp = W_p/ W_m;     % -, puberty weight as fraction of maximum weight
xi_W_E = (mu_V + mu_O(3) * m_Em * f)/ (w_O(2) + w_O(3) * m_Em * f); 
    % kJ/g, whole-body energy density (no reprod buffer), <E + E_V>

%% life span

pars_tm = [g; k; l_T; v_Hb; v_Hp; h_a/ (p_M/ E_G)^2; s_G]; 
%[t_m S_b S_p] = get_tm(pars_tm, f, l_b, l_p); a_m = t_m/ kT_M; % d, mean life span
[t_m S_b S_p] = get_tm_s(pars_tm, f, l_b, l_p/ l_i); a_m = t_m/ kT_M; % d, mean life span
% if E_Hj > E_Hb: l_i > 1
hT_W = (hT_a * f * kT_M * g/ 6)^(1/3); % 1/d, Weibull ageing rate
hT_G = s_G * f * kT_M * g;             % 1/d, Gompertz ageing rate

%% feeding

% scaled functional responses
[eb_min lb_min uE0_min info_eb_min] = get_eb_min([g; k; v_Hb]); % growth, maturation cease at birth
M_E0_min_b = L_m^3 * E_m * g * uE0_min/ mu_E; % mol, initial reserve (of embryo) at eb_min
if sum(info_eb_min) ~= 2
    fprintf('Warning: no convergence for eb_min\n')
end
if E_Hj == E_Hb
  ep_min  = get_ep_min([k; l_T; v_Hp]); % growth and maturation cease at puberty
else
  ep_min  = get_ep_min_metam([g; k; l_T; v_Hb; v_Hj; v_Hp]); % growth and maturation cease at puberty  
end
M_E0_min_p = L_m^3 * E_m * g * get_ue0([g; k; v_Hb], ep_min)/ mu_E; % mol, initial reserve (of embryo) at ep_min

% food densities
Kb_min = K * eb_min ./ (1 - eb_min);          % growth, maturation cease at birth
Kp_min = K * ep_min ./ (1 - ep_min);          % growth and maturation cease at puberty

% food intake
pT_Xb = pT_Am * f * L_b^2/ kap_X;             % J/d, food intake at birth
JT_XAb = f * JT_X_Am * L_b^2;                   % mol/d, food intake at birth
pT_Xj = pT_Am * f * L_j^2/ kap_X;             % J/d, food intake at metamorphosis
JT_XAj = f * JT_X_Am * L_j^2;                   % mol/d, food intake at metamorphosis
pT_Xp = pT_Am * f * L_p^2/ kap_X;             % J/d, food intake at puberty
JT_XAp = f * JT_X_Am * L_p^2;                   % mol/d, food intake at puberty
pT_Xi = pT_Am * f * L_i^2/ kap_X;             % J/d, ultimate food intake
JT_XAi = f * JT_X_Am * L_i^2;                   % mol/d, ultimate food intake

% clearance rates
CR_b = FT_m * L_b^2;                          % l/d, clearance rate at birth 
CR_j = FT_m * L_j^2;                          % l/d, clearance rate at metamorphosis
CR_p = FT_m * L_p^2;                          % l/d, clearance rate at puberty
CR_i = FT_m * L_i^2;                          % l/d, ultimate clearance rate

%% reproduction

pars_R = [kap; kap_R; g; kT_J; kT_M; L_T; vT; U_Hb; U_Hp];
if foetus == 1 % foetal development
  R_i = reprod_rate_foetus(L_i, f, pars_R); % d^-1
elseif E_Hj == E_Hb % egg development without metamorphosis
  R_i = reprod_rate(L_i, f, pars_R); % d^-1
else % egg development with metamorphosis
  pars_R = [pars_R; L_b; L_j; L_p]; % append lengths at b,j,p
  [R_i, UE0, info] = reprod_rate_metam(L_i, f, pars_R);
  if info ~= 1
    fprintf('warning in reprod_rate_metam: invalid parameter value combination for R_i \n')
  end  
  clear UE0
end
% very sensitive to U_Hb, which controls size at birth

% max gonado-somatic index of fully grown individual 
%   that spawns once per year see (4.89) of DEB3
GI = 365 * kT_M * g/ f/ (f + kap * g * y_V_E);
GI = GI * ((1 - kap) * f^3 - k_J * U_Hp/ L_i^2/ s_M^3); % mol E_R/ mol W

%% mass fluxes for L = L_i = f * L_m - L_T

p_ref = pT_Am * L_m^2;        % max assimilation power at max size
if U_Hj == U_Hb % no metamorphosis
  pars_pow = [kap; kap_R; g; kT_J; kT_M; L_T; vT; U_Hb; U_Hp];
  pACSJGRD = p_ref * scaled_power(L_i, f, pars_pow, l_b, l_p); % powers
else % metamorphosis
  pars_pow = [kap; kap_R; g; kT_J; kT_M; L_T; vT; U_Hb; U_Hj; U_Hp];
  pACSJGRD = p_ref * scaled_power_metam(L_i, f, pars_pow, l_b, l_p); % powers
end
pADG = pACSJGRD(:,[1 7 5])';  % assimilation, dissipation, growth power
J_O = eta_O * diag(pADG);     % J_X, J_V, J_E, J_P in rows, A, D, G in cols
J_M = - (n_M\n_O) * J_O;      % J_C, J_H, J_O, J_N in rows, A, D, G in cols
RQ = -(J_M(1,2) + J_M(1,3))/ (J_M(3,2) + J_M(3,3)); % mol C/ mol O, resp quotient
UQ = -(J_M(4,2) + J_M(4,3))/ (J_M(3,2) + J_M(3,3)); % mol N/ mol O, urin quotient
WQ = -(J_M(2,2) + J_M(2,3))/ (J_M(3,2) + J_M(3,3)); % mol H/ mol O, water quotient
SDA = J_M(3,1)/ J_O(1,1);     % mol O/mol X, specific dynamic action

VO = J_M(3,2)/ W_i/ 24/ X_gas;      % L/g.h, dioxygen use per gram max dry weight, <J_OD>

%% heat for L = L_i = f * L_m - L_T

p_Tt = sum(- J_O' * mu_O - J_M' * mu_M); % J/d, dissipating heat

%% population characteristics

if foetus == 1 % foetal development
  pars_rm = [kap kap_R g kT_J kT_M L_T vT U_Hb U_Hp hT_a s_G];
  [r_m Ea_m EL_m EL2_m EL3_m info_ssd] = ssd_iso_foetus(pars_rm, 1);
  if info_ssd ~= 1
    fprintf(['Warning: no convergence for sgr_iso_foetus for f = ', num2str(f),'\n']);
  end
  % f_r = f_ris0(pars_rm, 1.02 * ep_min(1));
  f_r = 1.02 * ep_min(1);
  [r_0 Ea_0 EL_0 EL2_0 EL3_0 info_ssd] = ssd_iso_foetus(pars_rm, f_r, 0);
elseif E_Hj == E_Hb  % egg development, no metamorphosis
  pars_rm = [kap kap_R g kT_J kT_M L_T vT U_Hb U_Hp hT_a s_G];
  [r_m Ea_m EL_m EL2_m EL3_m info_ssd] = ssd_iso(pars_rm, 1);
  if info_ssd ~= 1
    fprintf(['Warning: no convergence for sgr_iso for f = ', num2str(f),'\n']);
  end
  % f_r = f_ris0(pars_rm, 1.02 * ep_min(1));
  f_r = 1.02 * ep_min(1);
  [r_0 Ea_0 EL_0 EL2_0 EL3_0 info_ssd] = ssd_iso(pars_rm, f_r, 0);
else % egg development with metamorphosis
  pars_rm = [kap kap_R g kT_J kT_M L_T vT U_Hb U_Hj U_Hp hT_a s_G];
  [r_m Ea_m EL_m EL2_m EL3_m info_ssd] = ssd_iso_metam(pars_rm, 1);
  if info_ssd ~= 1
    fprintf(['Warning: no convergence for sgr_iso_metam for f = ', num2str(f),'\n']);
  end
  % f_r = f_ris0(pars_rm, 1.02 * ep_min(1));
  f_r = 1.5 * ep_min(1);
  [r_0 Ea_0 EL_0 EL2_0 EL3_0 info_ssd] = ssd_iso_metam(pars_rm, f_r, 0);
end
