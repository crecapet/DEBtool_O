%% Parameters for 'endosym'
%%   2 species each having 1 structure (V) and 1 reserve (E)
%%   each species eats one substrate (S) and one product
%%   integrating into a single 1 struct - 1 reverve organism in 8 steps
%% Control-parameters:
%%   hazard rates h1_V, h2_V, h1_S, h2_S, h1_P, h2_P (time integrations)
%%     or h (steady states)
%%   supply fluxes J1_Sr, J2_Sr (time integrations)
%%     or supply concentrations S1_r, S2_r (steady states)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Parameters for level 0: substitutable substrates

global h1_V h2_V h1_S h2_S h1_P h2_P ... % reactor drains
    J1_Sr J2_Sr S1_r S2_r ... % reactor feeding
    k1_E k2_E k1_M k2_M ...
    k1_S k2_S k1_P k2_P ...
    b1_S b2_S b1_P b2_P ...
    y1_EV y2_EV y1_ES y2_ES y1_EP y2_EP ...
    y1_PS y2_PS y1_PP y2_PP y1_PM y2_PM y1_PG y2_PG ...
    istate0 % initial state level 0 (for time-integration)

S1_r = 2; S2_r = 2;          % conc substrate in feed 
h = 0.1;                        % spec throughput rate of the chemostat
h1_V = h; h2_V = h; h1_S = h; h2_S = h; h1_P = h; h2_P = h;
  %% hazard rates equal to throughput rate  
J1_Sr = h*S1_r; J2_Sr = h*S2_r;  % supply fluxes from supply concentrations

k1_E = 1.5; k2_E = 1.5;   % reserve-turnover rate
k1_M = 1; k2_M = 1; % maintenance rate coeff
k1_S  = 0.5; k2_S  = 0.5; % dissociation rate
k1_P  = 0.5; k2_P  = 0.5; % dissociation rate

b1_S = 1; b2_S = 1;   % uptake of substrate
b1_P = 1; b2_P = 1;   % uptake of product

y1_EV = 1; y2_EV = 1; % yield of E on V (>1 since E -> V)
y1_ES = 1; y2_ES = 1; % yield of E on S 
y1_EP = 1; y2_EP = 1; % yield of E on P 

y1_PS = 1; y2_PS = 1; % yield of P on S-assimilation
y1_PP = 1; y2_PP = 1; % yield of P on P-assimilation
y1_PM = 1; y2_PM = 1; % yield of P on maintenance
y1_PG = 1; y2_PG = 1; % yield of P on growth

istate0 = [1 1 1 1 1 1 1 1]; % initial state values (8)
%% substrates, products, structure, res density, structure, res density
%% S1 S2 P1 P2 V1 m1 V2 m2

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Extra parameters for level 1: from substitutable to complentary substrates

global k1 k2 ki1_S ki2_S ki1_P ki2_P ...
    b1_SP b2_SP b1_PS b2_PS ...
    y1_Et y2_Et y1_St y2_St y1_Pt y2_Pt ...
    istate1 % initial state level 1 (for time-integration)

k1 = 0.1; k2 = 0.1;       % dissociation rate
ki1_S = 0.1; ki2_S = 0.1; % dissociation rate
ki1_P = 0.1; ki2_P = 0.1; % dissociation rate

b1_SP = 0.2; b2_SP = 0.2; % uptake of substrate 
b1_PS = 0.1; b2_PS = 0.1; % uptake of product

y1_Et = 0.8; y2_Et = 0.8; % yield of E on S+P -> E (production)
y1_St = 0.5; y2_St = 0.5; % yield of S on S+P -> E (consumption)
y1_Pt = 0.5; y2_Pt = 0.5; % yield of P on S+P -> E (consumption)

istate1 = [S1_r S2_r 1 1 .1 1 .1 1]; % initial state values (8)
%% substrates, products, structure, reserve density, structure, res density
%% S1 S2 P1 P2 V1 m1 V2 m2

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Extra parameters for level 2: complementary substrates

global istate2 % initial state level 2 (for time-integration)

istate2 = [S1_r S2_r 1 1 .1 1 .1 1]; % initial state values (8)
%% substrates, products, structure, reserve density, structure, res density
%% S1 S2 P1 P2 V1 m1 V2 m2

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Extra parameters for level 3: free, mantle and internal species 2

global b2_Sm b2_mS b2_Ss b2_sS ... % substrate transport
      b1_Pm b1_mP b2_Pm b2_mP b1_Ps b1_sP b2_Ps b2_sP ... % product transport 
      istate3 % initial state level 3 (for time-integration)
      %% pas op: dubbele definitie
      %% y_ES = y_Et/y_St; y_EP = y_Et/y_Pt

b2_Sm = 5; b2_mS = 5;   % substrate 2 transport to mantle <-> free
b2_Ss = 5; b2_sS = 5;   % substrate 2 transport to internal <-> mantle
b1_Pm = .1; b1_mP = .1; % product 1 transport to mantle  <-> free
b2_Pm = .1; b2_mP = .1; % product 2 transport to mantle  <-> free
b1_Ps = .1; b1_sP = .1; % product 1 transport to inernal <-> mantle
b2_Ps = .1; b2_sP = .1; % product 2 transport to inernal <-> mantle

%% y1_ES = 0.8; y2_ES = 0.8; % yield of E on S 
%% y1_EP = 0.2; y2_EP = 0.2; % yield of E on P 

istate3 = [S1_r S2_r S2_r S2_r 1 1 1 1 1 1 ...
	  .1 1 .1 1 .1 1 .1 1]; % initial state values (18) 
%% substrates, products, V,m-spec-1, V,m-spec-2, V,m-spec-m, V,m-spec-s
%% S1 S2 S2m S2s P1 P1m P1s P2 P2m P2s V1 m1 V2 m2 Vm mm Vs ms

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Extra parameters for level 4: internal species 2,
%%   S2, P1, P2 internal, mantle and free space
%%   host (species 1) feeds on internal P2 and mantle P2 

global rho1_P rho2_P ... % uptake
    istate4 % initial state level 4 (for time-integration)

rho1_P = 0.8; rho2_P = 0.9; % binding probabilities for product

istate4 = [S1_r S2_r S2_r S2_r 1 1 1 1 1 1 ...
	  .1 1 .1 1]; % initial state values (14) 
%% substrates, products, V,m-spec-1, V,m-spec-2
%% S1 S2 S2m S2s P1 P1m P1s P2 P2m P2s V1 m1 Vs ms

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Extra parameters for level 5: S2, P1, P2 internal and free space
%%   host and symbiont pass their products directly on flux basis

global istate5; % initial state level 5 (for time-integration)

istate5 = [S1_r S2_r S2_r 0 0 0 0 ...
	  .1 1 .1 1]; % initial state values (11) 
%% substrates, products, V,m-spec-1, V,m-spec-2 internal
%% S1 S2 S2s P1 P1s P2 P2s V1 m1 Vs ms

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Extra parameters for level 6: S2, P1, P2 free space only

global y1_PE y2_PE ... % product formation coupled to assimilation
    y12_PE y21_PE ... % product consumption
    istate6 % initial state level 6 (for time-integration)

%% constant ratio of structures for y1_PE, y2_PE > 0; k2_M > k1_M
%% k_E = k1_E = k2_E; k1 = k2 = 1e50; y1_PG = y2_PG = 0; y2_ES = 500;
%% y1_PM = y1_PE*y1_EV*(k_E/k1_M)*(k2_M - k1_M)/(k_E + k2_M);

y1_PE = 2; y2_PE = 2; % yield of P on assimilation
y12_PE = 0.2; y21_PE = 0.2; % yield of P on E

istate6 = [S1_r S2_r 0 0 .1 1 .1 1]; % initial state values (8) 
%% substrates, products, V,m-spec-1, V,m-spec-2
%% S1 S2 P1 P2 V1 m1 V2 m2

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Extra parameters for level 7: 1 structure, 2 reserves, excretion

global h_V h1_E h2_E ... % reactor drains
    kap1 kap2 ...        % uptake rates, recovery fractions
    istate7              % initial state level 7 (for time-integration)

h1_E = h; h2_E = h; h_V = h; % hazard rates equal to throughput rate  
kap1 = 0; kap2 = 0;  % fractions of rejected reserves back to reserves

y12_PE = 0.2; y21_PE = 0.2; % yield of P on E

istate7 = [S1_r S2_r 0 0 0 0 .1 1 1]; % initial state values (9) 
%% substrates, products, excreted reserves, structure, res densities
%% S1 S2 P1 P2 E1 E2 V m1 m2

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Extra parameters for level 8: 1 structure, 1 reserve, no excretion

global k k_M k_E  % max assimilation, maint rate coeff, reserve turnover rate
    y_EV          % growth costs
    istate8       % initial state level 8 (for time-integration)
    
k = 1;       % max assimilation rate
k_E = 3;     % reserve-turnover rate
k_M = 0.01;  % maintenance rate coeff
y_EV = 1.2;  % yield of E on V (>1 since E -> V)


istate8 = [S1_r S2_r 0 0 .1 1]; % initial state values (6)
%% substrates, products, structure, res density
%% S1, S2, P1, P2, V, m

%%%%%%%%%%%%%% end of parameter specification %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
