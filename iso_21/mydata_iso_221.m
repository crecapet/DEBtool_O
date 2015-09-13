%% mydata_iso_221
% created 2011/05/04 by Bas Kooijman, modified 2011/08/06
% isomorph with 1 structure
% 2 reserves: protein (1) and non-protein (2)
%  maintenance preferably paid from non-protein
%  fixed stochiometric requirements of protein and non-protein for growth
% 2 types of food
%  preference depends on stress of non-filled reserve

%% set parameters at T_ref = 293 K
M_X1      = 1e-3;   M_X2      = 1e-3;  % mol, size of food particle of type i
F_X1m     = 10;     F_X2m     = 10;    % dm^2/d.cm^2, {F_Xim} spec searching rates
y_P1X1    = 0.15;   y_P2X2    = 0.15;  % mol/mol, yield of feaces i on food i
y_E1X1    = 0.79;   y_E2X1    = 0.01;  % mol/mol, yield of reserve Ei on food X1 (protein, non-protein)
y_E1X2    = 0.01;   y_E2X2    = 0.79;  % mol/mol, yield of reserve Ei on food X2 (protein, non-protein)
J_X1Am    = 1.0e-3; J_X2Am    = 2.0e-3;% mol/d.cm^2, {J_XiAm} max specific ingestion rate for food Xi
v         = 0.05;   kap       = 0.8;   % cm/d, energy conductance, 
                                       % -, allocation fraction to soma
mu_E1     = 4e5;    mu_E2     = 6e5;   % J/mol, chemical potential of reserve i
mu_V      = 5e5;    j_E1M     = 0.09;  % J/mol, chemical potenial of structure
                                       % mol/d.mol, specific som maint costs
J_E1T     = 0;      MV        = 4e-3;  % mol/d.cm^2, {J_E1T}, spec surface-area-linked som maint costs J_E1T/ J_E2T = j_E1M/ j_E2M
                                       % mol/cm^3, [M_V] density of structure
k_J       = 0.002;  k1_J      = 0.002; % 1/d, mat maint rate coeff, spec rejuvenation rate                                    
rho1      = 0.01;   del_V     = 0.8;   % -, preference for reserve 1 to be used for som maint
                                       % -, threshold for death by shrinking
y_VE1     = 0.8;    y_VE2     = 0.8;   % mol/mol, yield of structure on reserve i 
kap_E1    = 0.00;   kap_E2    = 0.00;  % -, fraction of rejected mobilised flux that is returned to reserve
kap_R1    = 0.95;   kap_R2    = 0.95;  % -, reproduction efficiency for reserve i
E_Hb      = 1e1;    E_Hp      = 2e4;   % J, maturity thresholds at birth, puberty
T_A       = 8000;   h_H       = 1e-5;  % K, Arrhenius temperature
                                       % 1/d, hazerd due to rejuvenation
% pack parameters
par_iso_221 = [...
%      1       2       3       4       5       6       7       8
    M_X1;   M_X2;  F_X1m;  F_X2m; y_P1X1; y_P2X2; y_E1X1; y_E2X1;
%      9      10      11       12     13      14      15      16
  y_E1X2; y_E2X2; J_X1Am; J_X2Am;      v;    kap;  mu_E1;  mu_E2;
%     17      18      19      20      21      22      23      24     25     26
    mu_V;  j_E1M;  J_E1T;     MV;    k_J;   k1_J;   rho1;  del_V; y_VE1; y_VE2;
%     27      28      29      30      31      32      33      34
  kap_E1; kap_E2; kap_R1; kap_R2;   E_Hb;   E_Hp;    T_A;   h_H];

% set chemical indices
%    X1   X2    V   E1   E2   P1   P2  organics
n_O = [...
      1    1    1    1    1    1    1   ; % C
      1.8  1.8  1.8  1.61 2.0  1.8  1.8 ; % H
      0.5  0.5  0.5  0.33 0.6  0.5  0.6 ; % O
      0.2  0.2  0.2  0.28 0.0  0.2  0.0]; % N
  
%     C    H    O    N                 minerals
n_M = [...
      1    0    0    0; % C
      0    2    0    3; % H
      2    1    2    0; % O
      0    0    0    1];% N

%% set environmental variables
t = linspace(0,8e3,5e2)'; tXT = [t, t, t, t]; % d, time points
tXT(:,2) = 20000;     tXT(:,3) = 20000;         % mol/dm^2, food densities (don't need to be constant)
tXT(:,4) = 293;                               % K, temperature (does not need to be constant)

%% run iso_211
[var flux a_b M_E10 M_E20]  = iso_221(tXT, par_iso_221, n_O, n_M);

%% plot results
% unpack var: (n,9)-matrix with variables
%  cM_X1, cM_X2, M_E1, M_E2, M_V, M_H, cM_ER1, cM_ER2, h
%    cum food eaten, reserves, (max)structure, (max)maturity , cumulative allocation to reprod, hazard
 cM_X1 = var(:, 1); cM_X2   = var(:, 2); % mol, cumulative ingested food
 M_E1  = var(:, 3); M_E2    = var(:, 4); % mol, reserve
 E_H   = var(:, 5); max_E_H = var(:, 6); % J, maturity, max maturity
 M_V   = var(:, 7); max_M_V = var(:, 8); % mol, structure, max structure
 cM_E1R= var(:, 9); cM_E2R  = var(:,10); % mol, cumulative reprod
 S     = var(:,11);                      % -, survival probability

% unpack flux: (n,20)-matrix with fluxes (most of it still needs to be coded)
%  f1, f2, J_X1A, J_X2A, J_E1A, J_E2A, J_EC1, J_EC2, J_EM1, J_EM2, J_VG, ...
%  J_E1J, J_E2J, J_E1R, J_E2R, R, ...
%  J_C, J_H, J_O, J_N
%    func responses, food eaten, assim, mobilisation, som. maint, growth, ...
%    mat. maint, maturation, reprod rate, ...
%    CO2, H20, O2, NH3
 f1 = flux(:,1);   f2 = flux(:,2); % -, scaled functional response
 s1 = flux(:,3);   s2 = flux(:,4); % -, stress coefficients
 rho_X1X2 = flux(:,5); rho_X2X1 = flux(:,6); % -, scaled functional response 

close all % figures

figure
subplot(2,4,1)
plot(t, cM_X1, 'b', t, cM_X2, 'r')
xlabel('time since birth, d')
ylabel('cum food eaten, mol')
legend('X_1','X_2',2)

subplot(2,4,2)
plot(t, f1, 'b', t, f2, 'r')
xlabel('time since birth, d')
ylabel('scaled func resp, -')

subplot(2,4,3)
plot(t, M_E1, 'b', t, M_E2, 'r')
xlabel('time since birth, d')
ylabel('reserve, mol')
legend('protein','non-protein',4)

subplot(2,4,4)
plot(t, M_E1 ./ M_V, 'b', t, M_E2 ./ M_V, 'r')
xlabel('time since birth, d')
ylabel('reserve density, mol/mol')

subplot(2,4,5)
plot(t, M_V, 'g')
xlabel('time since birth, d')
ylabel('structure, mol')

subplot(2,4,6)
plot(t, (M_V/ MV).^(1/3), 'g')
xlabel('time since birth, d')
ylabel('length, cm')

subplot(2,4,7)
plot(t, E_H, 'g')
xlabel('time since birth, d')
ylabel('maturity, J')

subplot(2,4,8)
plot(t, cM_E1R, 'b', t, cM_E2R, 'r')
xlabel('time since birth, d')
ylabel('cum reprod, mol')

%subplot(2,4,9)
%plot(t, S, 'g')
%xlabel('time since birth, d')
%ylabel('survival prob, -')

figure
subplot(1,2,1)
plot(t, s1, 'b', t, s2, 'r')
xlabel('time since birth, d')
ylabel('stress coefficients, -')
legend('protein','non-protein',4)

subplot(1,2,2)
plot(t, rho_X1X2, 'b', t, rho_X2X1, 'r')
xlabel('time since birth, d')
ylabel('competition coefficients, -')
legend('\rho_{X_1X_2}','\rho_{X_2X_1}',2)
