  %% created 2000/10/26 by Bas Kooijman, modified 2011/04/26
  %% writes report on compound parameters and statistics
  %% called by 'pars_animal', after running "parscomp", "statistics"

txt_statistics = { ...
% 1 temperature
   'reference temp, T_ref, K '; 
   'actual temp, T, K ';
   'temperature correction factor, c_T, - ';
% 2 size at the start
   'initial reserve mass at growth ceasing at birth, M_E^0, mol ';
   'initial reserve mass at maturation ceasing at birth, M_E^0, mol ';
   'initial reserve mass at maturation ceasing at puberty, M_E^0, mol ';
   'initial reserve mass at f, M_E^0, mol ';
   'initial reserve energy at f, E_0, J ';
   'initial dry weight at f, W_d^0, g ';
% 3 size at birth
   'fraction of reserve left at birth, U_Eb/ U_E0, - ';
   'length at birth, L_b, cm ';
   'structural mass at birth, M_V^b, mol ';
   'physical length at birth, L_w^b, cm ';
   'dry weight at birth, W_d^b, g ';
   'birth weight as fraction of max, W_b/ W_m, - ';
% 4 size at metamorphis
   'length at metamorphis, L_j, cm ';
   'structural mass at metamorphis, M_V^j, mol ';
   'physical length at metamorphis, L_w^j, cm ';
   'dry weight at metamorphis, W_d^j, g ';
   'metamorphis weight as fraction of max, W_j/ W_m, - ';
% 5 size at puberty
   'length at puberty, L_p, cm ';
   'structural mass at puberty, M_V^p, mol ';
   'physical length at puberty, L_w^p, cm ';
   'dry weight at puberty, W_d^p, g ';
   'puberty weight as fraction of max, W_p/ W_m, - ';
% 6 final size
   'maximum length, L_m, cm ';
   'ultimate length, L_i, cm';
   'ultimate structural mass, M_Vi, mol ';
   'physical ultimate length, L_wi, cm ';
   'maximum dry weight, W_dm, g ';
   'ultimate dry weight, W_di, g';
   'fraction of weight that is structure, del_V, - ';
% 7 searching
   'max spec searching rate at T, {F_m}, l/d.cm^2';
   'clearance rate at birth, CR_b, l/d';
   'clearance rate at puberty, CR_p, l/d';
   'ultimate clearance rate, CR_i, l/d';
% 8 food densities
   'half saturation coefficient, K, M ';
   'food dens for maturation ceasing at birth, X_Jb, M ';
   'food dens for growth ceasing at birth, X_Gb, M ';
   'food dens for maturation and growth ceasing at puberty, X_Jp, M ';
% 9 scaled functional responses
   'scaled functional response, f, - ';
   'func resp for growth ceasing at birth, f_Gb, - ';
   'func resp for maturation ceasing at birth, f_Jb, - ';
   'func resp for maturation and growth ceasing at puberty, f_Jp, - ';
%10 feeding
   'max surface-spec feeding rate, {p_Xm}, J/d.cm^2 ';
   'max surface-spec feeding rate, {J_XAm}, mol/d.cm^2 ';
   'food energy intake at birth, p_Xb, J/d';
   'food mass intake at birth, J_XAb, mol/d';
   'food energy intake at puberty, p_Xp, J/d';
   'food mass intake at puberty, J_XAp, mol/d';
   'ultimate food energy intake, p_Xi, J/d';
   'ultimate food mass intake, J_XAi, mol/d';
   'max survival time when starved, [E_m]/[p_M], d';
%11 assimilation
   'max spec assimilation rate at T, {p_Am}, J/d.cm^2';
   'max surface-spec assimilation rate, {J_EAm}, mol/d.cm^2 ';
   'yield of reserve on food, y_EX, mol/mol ';
   'yield of faeces on food, y_PX, mol/mol ';
%12 reserve dynamics
   'energy conductance at T, v, cm/d';
   'maximum reserve residence time, t_E, d';
   'reserve capacity, [E_m], J/cm^3 ';
   'reserve capacity, m_Em, mol/mol ';
%13 maintenance
   'vol-specific somatic maintenance at T, [p_M], J/d.cm^3';
   'surface-specific som maintenance at T, {p_T}, J/d.cm^2';
   'heating length, L_T, cm ';
   'somatic maintenance rate coeff, k_M, 1/d';
   'maturity maint rate coefficient at T, k_J, 1/d';
   'maintenance ratio, k, - ';
   'volume-spec som maint costs, [J_EM], mol/d.cm^3 ';
   'surface-spec som maint costs, {J_ET}, mol/d.cm^2 ';
   'mass-spec somatic  maint costs, j_EM,  mol/mol.d ';
   'mass-spec maturity  maint costs, j_EJ, mol/mol.d ';
%14 respiration
   'specific dynamic action, SDA, mol O/ mol X ';
   'respiration quotient for L = L_m, RQ, mol C/ mol O ';
   'urination quotient for L = L_m, UQ, mol N/ mol O ';
   'watering quotient for L = L_m, WQ, mol H/ mol O ';
   'heat dissipation for L = L_i, p_T+, J/d ';
   'dioxygen use per gram max dry weight, L/g.h';
%15 growth
   'yield of structure on reserve, y_VE, mol/mol ';
   'growth efficiency, kappa_G, - ';
   'energy investment ratio, g, - ';
   'von Bertalanffy growth rate, r_B, 1/d ';
%16 reproduction
   'ultimate reproduction rate, R_i, 1/d ';
   'gonado-somatic index, GSI, mol/mol ';
%17 age & aging
   'age at birth, a_b, d ';
   'age at puberty, a_p, d ';
   'age at 99% of ultimate length, d';
   'mean life span, a_m, d ';
   'survival probability at birth, S_b, - ';
   'survival probability at puberty, S_p, - ';  
   'Weibull aging acceleration at T, h_a , 1/d^2';
   'Weibull aging rate at T, h_W, 1/d';
   'Gompertz aging rate at T, h_G, 1/d';
%18 conversion
   'vol-spec structural mass, [M_V], mol/cm^3 ';
   'vol-spec structural energy, [E_V], J/cm^3 ';
   'energy density of whole body, <E + E_V>, J/g ';
%19 population
   'maximum specific population growth rate, r_m, 1/d ';
   'mean age of juveniles + adults at f=1, Ea, d ';
   'mean structural length of juveniles + adults at f=1, EL, cm ';
   'mean squared structural length of juv + adults at f=1, EL^2, cm^2 ';
   'mean structural cubed length of juv + adults at f=1, EL^3, cm^3 ';
   'scaled func response at no pop growth, f_0, - ';
   'mean age of juveniles + adults at r=0, Ea, d ';
   'mean structural length of juveniles + adults at r=0, EL, cm ';
   'mean squared structural length of juv + adults at r=0, EL^2, cm^2 ';
   'mean cubed structural length of juv + adults at r=0, EL^3, cm^3 ';
  };

val_statistics = [ ...
    T_ref; T; TC;                           % 1 | 1 2 3
    M_E0_min_b; M_E0_min_p; M_E0; E_0; W_0; % 2 | 4 5 6 7 8 9
    del_Ub; L_b; M_Vb; Lw_b; W_b; del_Wb;   % 3 | 10 11 12 13 14 15
    L_j; M_Vj; Lw_j; W_j; del_Wj;           % 4 | 16 17 18 19 20
    L_p; M_Vp; Lw_p; W_p; del_Wp;           % 5 | 21 22 23 24 25
    L_m; L_i; M_Vi; Lw_i; W_m; W_i; del_V;  % 6 | 26 27 28 29 30 31 32
    FT_m; CR_b; CR_p; CR_i;                 % 7 | 33 34 35 36
    K; Kb_min; Kp_min;                      % 8 | 37 38 39 40
    f; eb_min; ep_min;                      % 9 | 41 42 43 44
    pT_Xm; JT_X_Am; pT_Xb;                  %10 | 45 46 47
      JT_XAb; pT_Xp; JT_XAp; pT_Xi; JT_XAi;%    | 48 49 50 51 52
      t_starve;                            %    | 53
    pT_Am; JT_E_Am; y_E_X; y_P_X;          % 11 | 54 55 56 57
    vT; t_E; E_m; m_Em;                    % 12 | 58 59 60 61
    pT_M; pT_T; L_T; kT_M; kT_J; k;        % 13 | 62 63 64 65 66 67
      JT_E_M; JT_E_T; jT_E_M; jT_E_J;      %    | 68 69 70 71
    SDA; RQ; UQ; WQ; p_Tt; VO;             % 14 | 72 73 74 75 76 77
    y_V_E; kap_G; g; r_B;                  % 15 | 78 79 80 81
    R_i; GI;                               % 16 | 82 83
    a_b; a_p; a_99; a_m; S_b; S_p;         % 17 | 84 85 86 87 88 89
      hT_a; hT_W; hT_G;                    %    | 90 91 92
    M_V; E_V; xi_W_E;                      % 18 | 93 94 95
    r_m; Ea_m; EL_m; EL2_m; EL3_m;         % 19 | 96 97 98 99 100
      f_r; Ea_0; EL_0; EL2_0; EL3_0;       %    | 101 102 103 104 105
    ];

if exist('file_name','var') == 0
  printpar(txt_statistics, val_statistics)
else
  fprintf([num2str(n_spec), ' ', species, '\n']);
end

txt_par = { ...     
  % 1 temperature
    'actual body temperature, T, K';
    'temp for which rate pars are given, T_ref, K';   
    'Arrhenius temp, T_A, K';
    'lower boundary tolerance range, T_L, K';
    'upper boundary tolerance range, T_H, K';
    'Arrhenius temp for lower boundary, T_AL, K';
    'Arrhenius temp for upper boundary, T_AH, K';
  % 2 feeding
    'scaled functional response, f, -';
  % 3 scaling
    'zoom factor, z, -';
    'shape coefficient to convert vol-length to physical length, del_M, -'
  % 4 assimilation
    'max spec searching rate, {F_m}, l/d.cm^2';
    'digestion efficiency of food to reserve, kap_X, -';
    'faecation efficiency of food to faeces, kap_X_P, -;';
  % 5 mobilisation & allocation
    'energy conductance, v, cm/d';
    'allocation fraction to soma, kap, -' ;
    'reproduction efficiency, kap_R, -';
  % 6 maintenance
    'vol-specific somatic maintenance, [p_M], J/d.cm^3';
    'surface-specific som maintenance, {p_T}, J/d.cm^2';
    'maturity maint rate coefficient, k_J, 1/d';
  % 7 growth
    'spec cost for structure, [E_G], J/cm^3';
  % 8 life stages
    'cumulated energy invested in maturation at birth, E_Hb,  J';
    'cumulated energy invested in maturation at metamorphosis, E_Hj,  J';
    'cumulated energy invested in maturation at puberty, E_Hp,  J';
  % 9 aging
    'Weibull aging acceleration, h_a, 1/d^2';
    'Gompertz stress coefficient, s_G, -';
     };

val_par =[ ... 
T; T_ref; T_A; T_L; T_H; T_AL ;T_AH % 1
f;                                  % 2
z; del_M;                           % 3
F_m;  kap_X; kap_X_P;               % 4
v; kap; kap_R;                      % 5
p_M;  p_T; k_J;                     % 6
E_G                                 % 7
E_Hb; E_Hj; E_Hp;                   % 8
h_a ; s_G                           % 9
];

% printpar(txt_par, val_par)

txt_mudn = {... % used in report_xls
    'chemical potentials for X V E P, mu_O, J/mol'; 
    'specific densities for X V E P, d_O, g/cm^3'; 
    'chemical indices for X V E P, n_O, -'};

