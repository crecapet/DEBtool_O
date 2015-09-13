function [var flux a_b M_E10 M_E20]  = iso_221(tXT, p, n_O, n_M)
% [var flux a_b M_E10 M_E20]  = iso_221(tXT, p, n_O, n_M)
% created 2011/04/29 by Bas Kooijman, modified 2011/10/31
% 2-food, 2-reserve, 1-structure isomorph
%   model is presented in comment for 5.2.7 of DEB3
% tXT: (n,4)-matrix of time since birth, food densities, temperature
%  tXT(1; [2 3]) serves to specify the maternal effect, otherwise food before birth is ignored
% p: vector of parameters (see diso_221)
% n_O: (4,7)-matrix with chemical indices for organics X1, X2, V, E1, E2, P1, P2
% n_M: (4,4)-matrix with chemical indices for minerals C, H, O, N
% var: (n,9)-matrix with variables
%  cM_X1, cM_X2, M_E1, M_E2, M_V, M_H, cM_ER1, cM_ER2, h
%    cum food eaten, reserves, (max)structure, (max)maturity , cumulative allocation to reprod, hazard
% flux: (n,20)-matrix with fluxes
%  f1, f2, J_X1A, J_X2A, J_E1A, J_E2A, J_EC1, J_EC2, J_EM1, J_EM2, J_VG, ...
%  J_E1J, J_E2J, J_E1R, J_E2R, R, ...
%  J_C, J_H, J_O, J_N
%    func responses, food eaten, assim, mobilisation, som. maint, growth, ...
%    mat. maint, maturation, reprod rate, ...
%    CO2, H20, O2, NH3
% a_b: scalar with age at birth at tXT(1,4)
% M_E10, M_E20: scalars with intitial reserves

global tXT_iso_221 par_iso_221 % for transfer to diso_221
tXT_iso_221 = tXT; par_iso_221 = p;

% unpack some parameters, see diso_211 for a full list
M_X1      = p( 1); M_X2      = p( 2); % mol, size of food particle of type i
F_X1m     = p( 3); F_X2m     = p( 4); % dm^2/d.cm^2, {F_Xim} spec searching rates
y_E1X1    = p( 7); y_E2X1    = p( 8); % mol/mol, yield of reserve Ei on food X1
y_E1X2    = p( 9); y_E2X2    = p(10); % mol/mol, yield of reserve Ei on food X2
J_X1Am    = p(11); J_X2Am    = p(12); % mol/d.cm^2, {J_XiAm} max specific ingestion rate for food Xi
v         = p(13); kap       = p(14); % cm/d, energy conductance, 
                                      % -, allocation fraction to soma
mu_E1     = p(15); mu_E2     = p(16); % J/mol, chemical potential of reserve i
mu_V      = p(17); j_E1M     = p(18); % J/mol, chemical potential of structure
                                      % mol/d.mol, spec som maint for reserve 1
J_E1T     = p(19); MV        = p(20); % mol/d.cm^2, {J_E1T}, spec surface-area-linked som maint costs J_E1T/ J_E2T = j_E1M/ j_E2M
                                      % mol/cm^3, [M_V] density of structure
k_J       = p(21);                    % 1/d, maturity maint rate coefficient
rho1      = p(23);                    % -, preference for reserve 1 for som maintenance
y_VE1     = p(25); y_VE2     = p(26); % mol/mol, yield of structure on reserve i 
kap_E1    = p(27); kap_E2    = p(28); % -, fraction of rejected mobilised flux that is returned to reserve
E_Hb      = p(31);                    % J, maturity at birth
T_A       = p(33);                    % K, Arrhenius temperature

% get state at birth and M_E0
TC = tempcorr(tXT(1,4), 293, T_A); % -, temperature correction factor, T_ref = 293 K
X1 = tXT(1,2); X2 = tXT(1,3);                                 % M, food densities
K1 = J_X1Am/ F_X1m; K2 = J_X2Am/ F_X2m;                       % M, half saturation coefficients
f1 = X1/ (X1 + K1); f2 = X2/ (X2 + K2);                       % -, scaled functional responses
J_E1Am_X1 = y_E1X1 * J_X1Am; J_E2Am_X1 = y_E2X1 * J_X1Am;     % mol/d, max assim rate
J_E1Am_X2 = y_E2X1 * J_X2Am; J_E2Am_X2 = y_E2X2 * J_X2Am;     % mol/d, max assim rate
m_E1b = max(f1 * J_E1Am_X1/ v/ MV, f2 * J_E1Am_X2/ v/ MV);    % mol/mol, reserve density 1 at birth
m_E2b = max(f1 * J_E2Am_X1/ v/ MV, f2 * J_E2Am_X2/ v/ MV);    % mol/mol, reserve density 2 at birth
pars_iso_21 = [TC * v; kap; mu_E1; mu_E2; mu_V; TC * j_E1M; MV; TC * k_J; rho1; y_VE1; y_VE2; kap_E1; kap_E2; E_Hb];
[L_b a_b M_E10 M_E20 info] = iso_21(m_E1b, m_E2b, pars_iso_21);
if info == 0
  fprintf('warning in iso_21: no convergence for embryo states \n')
end
M_Vb = MV * L_b^3; M_E1b = m_E1b * M_Vb; M_E2b = m_E2b * M_Vb; % mol, masses at birth

% compose variables at birth
%        1     2       3       4      5      6     7      8      9      10     11
%      cM_X1  cM_X2  M_E1    M_E2    E_H  max_E_H M_V  max_M_V cM_ER1  cM_ER2   S
var_b = [0,    0,   M_E1b,  M_E2b,  E_Hb,  E_Hb, M_Vb,  M_Vb,    0,      0,     1]; % mol, 

% initialize r in sgr_iso_21 via call to sgr_iso_21 with r_0 specified; sgr_iso_21 works with continuation
%   first get dL_b from gr_iso_21; previous call to iso_21 left gr_iso_21 v_B at birth
j_E2M = j_E1M * mu_E1/ mu_E2;     % mol/d.mol, spec som maint for 2
J_E2T = J_E1T * mu_E2/ mu_E1;     % mol/d.cm^2
j_E2S = j_E2M + J_E2T/ MV/ L_b;   % mol/d.mol
j_E1S = j_E1M + J_E1T/ MV/ L_b;   % mol/d.mol total spec somatic maint
dL_b = gr_iso_21(L_b, m_E1b, m_E2b, TC * j_E1M, TC * j_E2M, y_VE1, y_VE2, TC * v, kap, rho1); % cm/d, change in L at birth
r = 3 * dL_b/ L_b; % 1/d, specific growth rate at birth at T(0), but som maint might change at birth
mu_EV = mu_E1/ mu_V; k_E = v/ L_b;% -, 1.d: ratio of chem pot, reserve turnover rate
r = sgr_iso_21 (m_E1b, m_E2b, TC * j_E1S, TC * j_E2S, y_VE1, y_VE2, mu_EV, TC * k_E, kap, rho1, r); % 1/d, sgr

% get variables
var = lsode(@diso_221, var_b, tXT(:,1));

% unpack variables
M_E1 = var(:,3); M_E2 = var(:,4); E_H = var(:,5); M_V = var(:,7); 
m_E1 = M_E1 ./ M_V; m_E2 = M_E2 ./ M_V;

% get fluxes
J_E1Am_X1 = y_E1X1 * J_X1Am; J_E1Am_X2 = y_E1X2 * J_X2Am; % mol/d.cm^2, max spec assim rate for reserve 1 
J_E2Am_X1 = y_E2X1 * J_X1Am; J_E2Am_X2 = y_E2X2 * J_X2Am; % mol/d.cm^2, max spec assim rate for reserve 2
m_E1m = max(J_E1Am_X1/ v/ MV, J_E1Am_X2/ v/ MV);
m_E2m = max(J_E2Am_X1/ v/ MV, J_E2Am_X2/ v/ MV);
s1 = max(0, 1 - m_E1/ m_E1m); s2 = max(0, 1 - m_E2/ m_E2m);
rho_X1X2 = s1 * max(0, M_X1/ M_X2 * y_E1X1/ y_E1X2 - 1) + s2 * max(0, M_X1/ M_X2 * y_E2X1/ y_E2X2 - 1);
rho_X2X1 = s1 * max(0, M_X2/ M_X1 * y_E1X2/ y_E1X1 - 1) + s2 * max(0, M_X2/ M_X1 * y_E2X2/ y_E2X1 - 1);
h_X1Am = J_X1Am/ M_X1; h_X2Am = J_X2Am/ M_X2;
alpha_X1 = h_X1Am + F_X1m * X1 + F_X2m * rho_X2X1 * X2; 
alpha_X2 = h_X2Am + F_X2m * X2 + F_X1m * rho_X1X2 * X1;
beta_X1 = F_X1m * X1 * (1 - rho_X1X2); beta_X2 = F_X2m * X2 * (1 - rho_X2X1);
f1 = (alpha_X2 * F_X1m * X1 - beta_X1 * F_X2m * X2) ./ (alpha_X1 .* alpha_X2 - beta_X1 .* beta_X2);
f2 = (alpha_X1 * F_X2m * X2 - beta_X2 * F_X1m * X1) ./ (alpha_X1 .* alpha_X2 - beta_X1 .* beta_X2);
f1 = f1 .* (E_H > E_Hb); f2 = f2 .* (E_H > E_Hb);

flux = [f1, f2, s1, s2, rho_X1X2, rho_X2X1]; 

%% subfunction diso_221

function dvar = diso_221(var, t)
% ode's for iso_221
% t: scalar time since birth
% var: 11-vector with states:
%   cM_X1, cM_X2, M_E1, M_E2, M_H, max_M_H, M_V, max_M_V, cM_ER1, cM_ER2, S
% tXT: (n,3)-matrix with time, X1, X2, T
% p: 33-vector with par values (see below)
% dvar: 11-vector with d/dt var

global tXT_iso_221 par_iso_221

p = par_iso_221;
% unpack parameters
M_X1      = p( 1); M_X2      = p( 2); % mol, size of food particle of type i
F_X1m     = p( 3); F_X2m     = p( 4); % dm^2/d.cm^2, {F_Xim} spec searching rates
%y_P1X1    = p( 5); y_P2X2    = p( 6); % mol/mol, yield of feaces i on food i
y_E1X1    = p( 7); y_E2X1    = p( 8); % mol/mol, yield of reserve Ei on food X1
y_E1X2    = p( 9); y_E2X2    = p(10); % mol/mol, yield of reserve Ei on food X2
J_X1Am    = p(11); J_X2Am    = p(12); % mol/d.cm^2, {J_XiAm} max specific ingestion rate for food Xi
v         = p(13); kap       = p(14); % cm/d, energy conductance, 
                                      % -, allocation fraction to soma
mu_E1     = p(15); mu_E2     = p(16); % J/mol, chemical potential of reserve i
mu_V      = p(17); j_E1M     = p(18); % J/mol, chemical potenial of structure
                                      % mol/d.mol, specific som maint costs
J_E1T     = p(19); MV        = p(20); % mol/d.cm^2, {J_E1T}, spec surface-area-linked som maint costs J_E1T/ J_E2T = j_E1M/ j_E2M
                                      % mol/cm^3, [M_V] density of structure
k_J       = p(21); k1_J      = p(22); % 1/d, mat maint rate coeff, spec rejuvenation rate                                    
rho1      = p(23); del_V     = p(24); % -, preference for reserve 1 to be used for som maint
                                      % -, threshold for death by shrinking
y_VE1     = p(25); y_VE2     = p(26); % mol/mol, yield of structure on reserve i 
kap_E1    = p(27); kap_E2    = p(28); % -, fraction of rejected mobilised flux that is returned to reserve
kap_R1    = p(29); kap_R2    = p(30); % -, reproduction efficiency for reserve i
E_Hb      = p(31); E_Hp      = p(32); % J, maturity thresholds at birth, puberty
T_A       = p(33); h_H       = p(34); % K, Arrhenius temperature
                                      % 1/d, hazerd due to rejuvenation
                                      
% unpack variables
%cM_X1 = var( 1); cM_X2   = var( 2); % mol, cumulative ingested food
 M_E1  = var( 3); M_E2    = var( 4); % mol, reserve
 E_H   = var( 5); max_E_H = var( 6); % J, maturity, max maturity
 M_V   = var( 7); max_M_V = var( 8); % mol, structure, max structure
%cM_E1R= var( 9); cM_E2R  = var(10); % mol, cumulative reprod
 S     = var(11);                    % -, survival probability

tXT = tXT_iso_221;
% get environmental variables at age t (linear interpolation)
X1 = spline1(t, tXT(:,[1 2])); % mol/cd^2, food density of type 1
X2 = spline1(t, tXT(:,[1 3])); % mol/cd^2, food density of type 1 
T  = spline1(t, tXT(:,[1 4])); % K, temperature 

if E_H < E_Hb % no assimilation before birth or surface-linked maintenance
  X1 = 0; X2 = 0;
end

% help quantities
L = (M_V/ MV)^(1/3);               % cm, structural length
k_E = v/ L;                        % 1/d,  reserve turnover rate
mu_EV = mu_E1/ mu_V;               % -, ratio of chemical potential
m_E1 = M_E1/ M_V; m_E2 = M_E2/ M_V;% mol/mol, reserve density
% somatic maintenance
j_E2M = j_E1M * mu_E1/ mu_E2;      % mol/d.mol
J_E2T = J_E1T * mu_E2/ mu_E1;      % mol/d.cm^2
% if E_H < E_Hb % no surface-linked maintenance
%   J_E1T = 0; J_E2T = 0;
% end
j_E1S = j_E1M + J_E1T/ MV/ L;      % mol/d.mol total spec somatic maint
j_E2S = j_E2M + J_E2T/ MV/ L;      % mol/d.mol

% correct rates for temperature
TC = tempcorr(T, 293, T_A); % -, temperature correction factor, T_ref = 293 K
F_X1m     = TC * F_X1m;  F_X2m     = TC * F_X2m;  % dm^2/d.cm^2, {F_Xim} spec searching rates
J_X1Am    = TC * J_X1Am; J_X2Am    = TC * J_X2Am; % mol/d.cm^2, {J_EiAm^Xi} max specfific assim rate for food X1
j_E1S     = TC * j_E1S;  j_E2S     = TC * j_E2S;  % mol/d.mol, specific som maint costs
v         = TC * v;      k_E = TC * k_E;          % cm/d, 1/d, energy conductance, reserve turnover rate
k_J       = TC * k_J;    k1_J      = TC * k1_J;   % 1/d mat maint rate coeff, spec rejuvenation rate

% feeding
J_E1Am_X1 = y_E1X1 * J_X1Am; J_E1Am_X2 = y_E1X2 * J_X2Am; % mol/d.cm^2, max spec assim rate for reserve 1 
J_E2Am_X1 = y_E2X1 * J_X1Am; J_E2Am_X2 = y_E2X2 * J_X2Am; % mol/d.cm^2, max spec assim rate for reserve 2
m_E1m = max(J_E1Am_X1/ v/ MV, J_E1Am_X2/ v/ MV);          % mol/mol, max reserve 1 density
m_E2m = max(J_E2Am_X1/ v/ MV, J_E2Am_X2/ v/ MV);          % mol/mol, max reserve 2 density
s1 = max(0, 1 - m_E1/ m_E1m); s2 = max(0, 1 - m_E2/ m_E2m);% -, stress factors for reserve 1, 2
rho_X1X2 = s1 * max(0, M_X1/ M_X2 * y_E1X1/ y_E1X2 - 1) + s2 * max(0, M_X1/ M_X2 * y_E2X1/ y_E2X2 - 1);
rho_X2X1 = s1 * max(0, M_X2/ M_X1 * y_E1X2/ y_E1X1 - 1) + s2 * max(0, M_X2/ M_X1 * y_E2X2/ y_E2X1 - 1);
h_X1Am = J_X1Am/ M_X1; h_X2Am = J_X2Am/ M_X2;             % #/d.cm^2, max spec feeding rates
alpha_X1 = h_X1Am + F_X1m * X1 + F_X2m * rho_X2X1 * X2; 
alpha_X2 = h_X2Am + F_X2m * X2 + F_X1m * rho_X1X2 * X1;
beta_X1 = F_X1m * X1 * (1 - rho_X1X2);  beta_X2 = F_X2m * X2 * (1 - rho_X2X1);
f1 = (alpha_X2 * F_X1m * X1 - beta_X1 * F_X2m * X2)/ (alpha_X1 * alpha_X2 - beta_X1 * beta_X2);
f2 = (alpha_X1 * F_X2m * X2 - beta_X2 * F_X1m * X1)/ (alpha_X1 * alpha_X2 - beta_X1 * beta_X2);
dcM_X1 = f1 * J_X1Am * L^2; dcM_X2 = f2 * J_X2Am * L^2; % mol/d, feeding rates

% assimilation
J_E1A = f1 * y_E1X1 * J_X1Am + f2 * y_E1X2 * J_X2Am; % mol/d.cm^2, {J_E1A}, specific assimilation flux
J_E2A = f1 * y_E2X1 * J_X1Am + f2 * y_E2X2 * J_X2Am; % mol/d.cm^2, {J_E2A}, specific assimilation flux
j_E1A = J_E1A/ MV/ L; j_E2A = J_E2A/ MV/ L;          % mol/d.mol, {J_EA}/ L.[M_V], specific assim flux

% reserve dynamics
[r j_E1_S j_E2_S j_E1C j_E2C info] = ...         % 1/d, specific growth rate, ....
    sgr_iso_21(m_E1, m_E2, j_E1S, j_E2S, y_VE1, y_VE2, mu_EV, k_E, kap, rho1); % use continuation
if info == 0 % try to repair in case of lack of convergence by starting from r_0 = 1e-4
  [r j_E1_S j_E2_S j_E1C j_E2C info] = ...       % 1/d, specific growth rate, ....
    sgr_iso_21(m_E1, m_E2, j_E1S, j_E2S, y_VE1, y_VE2, mu_EV, k_E, kap, rho1, 1e-4);
  if info == 1
    fprintf('diso_221 message: successful repair of lack of convergence\n');
  else % info == 0
    fprintf('diso_221 warning: sgr_iso_21 does not convergence\n');
  end
end

j_V_S = max(0, -r);                                % mol/d.mol, specific shrinking rate
j_E1P = kap * j_E1C - j_E1_S - (r + j_V_S)/ y_VE1; % mol/d.mol, rejected flux
j_E2P = kap * j_E2C - j_E2_S - (r + j_V_S)/ y_VE2; % mol/d.mol
dm_E1 = j_E1A - j_E1C + kap_E1 * j_E1P - r * m_E1; % mol/d.mol, change in reserve density
dm_E2 = j_E2A - j_E2C + kap_E2 * j_E2P - r * m_E2; % mol/d.mol
dM_E1 = M_V * (dm_E1 + r * m_E1);                  % mol/d, change in reserve
dM_E2 = M_V * (dm_E2 + r * m_E2);                  % mol/d
J_E1C = M_V * j_E1C; J_E2C = M_V * j_E2C;          % mol/d, mobilisation rates
p_C = mu_E1 * J_E1C + mu_E2 * J_E2C;               % J/d, total mobilisation power

% growth
dM_V = r * M_V;                                    % mol/d, growth rate (of structure)
dmax_M_V = max(0, dM_V);                           % mol/d, max value of structure

% maturation
dE_H = (1 - kap) * p_C - k_J * E_H;                % J/d, maturation if juvenile
if E_H >= E_Hp && dE_H >= 0 % adult 
  dE_H = 0;                                        % J/d, no maturation if adult
elseif dE_H < 0
  dE_H = - k1_J * (E_H - (1 - kap) * p_C/ k_J);    % J/d, rejuvenation
end
dmax_E_H = max(0, dE_H);                           % J/d, max value of maturity

% reproduction in adults
J_E1R = J_E1C * (1 - kap - k_J * E_H/ p_C);        % mol/d, allocation to reprod from res 1
J_E2R = J_E2C * (1 - kap - k_J * E_H/ p_C);        % mol/d, allocation to reprod from res 2
dcM_E1R = kap_R1 * J_E1R * (E_H >= E_Hp);          % mol/d, accumulation in reprod buffer
dcM_E2R = kap_R2 * J_E2R * (E_H >= E_Hp);          % mol/d, accumulation in reprod buffer

% survival due to shrinking, rejuvenation
h = 1e2 * (M_V < del_V * max_M_V) + h_H * (1 - E_H/ max_E_H); % #/d, hazard rate
dS = - S * h;                                      % 1/d, change in survival probability

% pack output
dvar = [dcM_X1; dcM_X2; dM_E1; dM_E2; dE_H; dmax_E_H; dM_V; dmax_M_V; dcM_E1R; dcM_E2R; dS];
                