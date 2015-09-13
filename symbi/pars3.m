%% Parameters for "endosym"
%%   2 interacting species each having 1 structure (V) and 1 reserve (E)
%%   each species eats one substrate (S) and one product (P)
%%   species 2 in free space, mantle, internal; obligate symbiontic
%%
%% Control-parameters:
%%   hazard rates h1_V, h2_V, h1_S, h2_S, h1_P, h2_P or h
%%   supply fluxes J1_Sr, J2_Sr or supply concentrations S1_r, S2_r

global h1_V h2_V h1_S h2_S h1_P h2_P h ... % reactor drains
    J1_Sr J2_Sr S1_r S2_r ... % reactor feeding
      k1_E k2_E k1_M k2_M ... % res turnover, maintenance
      k1 k2 ... % max assimilation
      b1_S b2_S b1_P b2_P ... % uptake
      b2_Sm b2_mS b2_Ss b2_sS ... % substrate transport
      b1_Pm b1_mP b2_Pm b2_mP b1_Ps b1_sP b2_Ps b2_sP ... % product transport 
      y1_EV y2_EV y1_es y2_es y1_ep y2_ep ... % y_ES = y_Et/y_St; y_EP = y_Et/y_Pt
      y1_PS y2_PS y1_PP y2_PP y1_PM y2_PM y1_PG y2_PG ...
      istate3 % initial values of state variables

h = 0.002;                         % spec throughput rate of the chemostat
S1_r = 100; S2_r = 200;          % conc substrate in feed 
h1_V=h;h2_V=h;h1_S=h;h2_S=h;h1_P=h;h2_P=h; % hazard rates equal to throughput rate  
J1_Sr = h*S1_r; J2_Sr = h*S2_r;  % supply fluxes from supply concentrations

k1_E = 2.5;  k2_E = 3.0;  % reserve-turnover rate
k1_M = 0.002; k2_M = 0.004; % maintenance rate coeff
k1 = 1.5; k2 = 1.7;       % max assimilation rate

b1_S  = 0.1; b2_S  = 0.1; % uptake of substrate
b1_P  = 0.2; b2_P  = 0.2; % uptake of product

b2_Sm = 1; b2_mS = 1; % substrate 2 transport to mantle <-> free
b2_Ss = 1; b2_sS = 1; % substrate 2 transport to internal <-> mantle
b1_Pm = 1; b1_mP = 1; % product 1 transport to mantle <-> free
b2_Pm = 1; b2_mP = 1; % product 2 transport to mantle <-> free
b1_Ps = 1; b1_sP = 1; % product 1 transport to inernal <-> mantle
b2_Ps = 1; b2_sP = 1; % product 2 transport to inernal <-> mantle

y1_EV = 1.2; y2_EV = 1.2; % yield of E on V (>1 since E -> V)
y1_es = 0.9/0.7; y2_es = 0.9/0.7; % yield of E on S 
y1_ep = 0.9/0.2; y2_ep = 0.9/0.2; % yield of E on P 

y1_PS = 0.2; y2_PS = 0.2; % yield of P on S-assimilation
y1_PP = 0.2; y2_PP = 0.2; % yield of P on P-assimilation
y1_PM = 0.6; y2_PM = 0.6; % yield of P on maintenance
y1_PG = 0.0; y2_PG = 0.0; % yield of P on growth

istate3 = [S1_r S2_r S2_r S2_r 100 100 100 150 150 150 ...
	  10 0.17 12 0.18 13 0.19 14 0.2]; % initial state values (18) 
%% substrates, products, V,m-spec-1, V,m-spec-2, V,m-spec-m, V,m-spec-s
%% S1 S2 S2m S2s P1 P1m P1s P2 P2m P2s V1 m1 V2 m2 Vm mm Vs ms






