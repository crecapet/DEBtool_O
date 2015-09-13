%% Parameters for "endosym"
%%   2 interacting species each having 1 structure (V) and 1 reserve (E)
%%   each species eats one substrate (S) and one product (P)
%% Internal population of species 2 only; no mantle space
%% Substrate 2, and product 1 and 2 in species 1 and in environment (free)
%%
%% Control-parameters:
%%   hazard rates h1_V, h2_V, h1_S, h2_S, h1_P, h2_P or h
%%   supply fluxes J1_Sr, J2_Sr or supply concentrations S1_r, S2_r

global h1_V h2_V h1_S h2_S h1_P h2_P h ... % reactor drains
      J1_Sr J2_Sr S1_r S2_r ... % reactor feeding
      k1_E k2_E k1_M k2_M ... % res turnover, maintenance
      k1 k2 ... % max assimilation
      b1_S b2_S b1_P b2_P rho1_P rho2_P ... % uptake
      b2_Ss b2_sS ... % substrate transport
      b1_Ps b1_sP b2_Ps b2_sP ... % product transport 
      y1_EV y2_EV y1_es y2_es y1_ep y2_ep ... % costs for structure, reserves
      y1_PS y2_PS y1_PP y2_PP y1_PM y2_PM y1_PG y2_PG ... % product yields
      istate5 % initial values of state variables

h = 0.002;                       % spec throughput rate of the chemostat
S1_r = 100; S2_r = 200;          % conc substrate in feed 
h1_V=h;h2_V=h;h1_S=h;h2_S=h;h1_P=h;h2_P=h; % hazard rates equal to throughput rate  
J1_Sr = h*S1_r; J2_Sr = h*S2_r;  % supply fluxes from supply concentrations

k1_E = 2.5;  k2_E = 3.0;    % reserve-turnover rate
k1_M = 0.002; k2_M = 0.004; % maintenance rate coeff
k1 = 1.5; k2 = 1.7;         % max assimilation rate

b1_S  = 0.1; b2_S  = 0.1;   % uptake of substrate
b1_P  = 0.2; b2_P  = 0.2;   % uptake of product
rho1_P = 0.8; rho2_P = 0.9; % binding probabilities for products

b2_Ss = 1; b2_sS = 1; % substrate 2 transport to internal <-> free
b1_Ps = 1; b1_sP = 1; % product 1 transport to inernal <-> free
b2_Ps = 1; b2_sP = 1; % product 2 transport to inernal <-> free

y1_EV = 1.2; y2_EV = 1.2; % yield of E on V (>1 since E -> V)
y1_es = 0.9/0.7; y2_es = 0.9/0.7; % yield of E on S
y1_ep = 0.9/0.2; y2_ep = 0.9/0.2; % yield of E on P

y1_PS = 0.2; y2_PS = 0.2; % yield of P on S-assimilation
y1_PP = 0.2; y2_PP = 0.2; % yield of P on P-assimilation
y1_PM = 0.6; y2_PM = 0.6; % yield of P on maintenance
y1_PG = 0.0; y2_PG = 0.0; % yield of P on growth

istate5 = [S1_r S2_r S2_r 150 150 200 200 ...
	  10 1.1 15 1.2]; % initial state values (11) 
%% substrates, products, V,m-spec-1, V,m-spec-2 internal
%% S1 S2 S2s P1 P1s P2 P2s V1 m1 Vs ms






