%% Parameters for "endosym"
%%   1 species having 1 structure (V) and 2 reserves (E)
%%   each res assimilates one substrate (S) and one product (P)
%% Substrates and products and excreted reserves in environment
%%
%% Control-parameters:
%%   hazard rates h_V, h1_S, h2_S, h1_P, h2_P, h1_E, h2_E or h
%%   supply fluxes J1_Sr, J2_Sr or supply concentrations S1_r, S2_r

global h h_V h1_S h2_S h1_P h2_P h1_E h2_E ... % reactor drains
    J1_Sr J2_Sr S1_r S2_r ... %reactor feeding
      k1_E k2_E k1_M k2_M ... % res turnover, maintenance
      k1 k2 ... % max assimilation
      b1_S b2_S kap1 kap2 ... % uptake rates, recovery fractions
      y1_EV y2_EV y1_es y2_es y12_PE y21_PE ... % costs for structure, reserves
      y1_PE y2_PE y1_PM y2_PM y1_PG y2_PG ... % product yields
      istate7; % initial values of state variables

h = 0.1;                        % spec throughput rate of the chemostat
S1_r = 100; S2_r = 100;         % conc substrate in feed 
h_V=h;h1_S=h;h2_S=h;h1_P=h;h2_P=h;h1_E=h;h2_E=h; % hazard rates equal to throughput rate  
J1_Sr = h*S1_r; J2_Sr = h*S2_r; % supply fluxes from supply concentrations

k1_E = 2.5;  k2_E = 3.0;      % reserve-turnover rate
k1_M = 0.002; k2_M = 0.004;   % maintenance rate coeff
k1 = 1.5; k2 = 1.7;           % max assimilation rate

b1_S  = 0.1; b2_S  = 0.1; % uptake of substrate
kap1 = 0; kap2 = 0;       % fractions of rejected reserves back to reserves

y1_EV = 1.2; y2_EV = 1.2;   % yield of E on V (>1 since E -> V)
y1_es = 0.9/0.7; y2_es = 0.9/0.7;   % yield of E on S 
y12_PE = 0.2; y21_PE = 0.2; % yield of P on E

y1_PE = 2; y2_PE = 2;     % yield of P on assimilation
y1_PM = 0.6; y2_PM = 0.6; % yield of P on maintenance
y1_PG = 0.0; y2_PG = 0.0; % yield of P on growth

istate7 = [S1_r S2_r .011 0.012 0.013 0.014 0.1 1.1 1];
				              % initial state values (9) 
%% substrates, products, excreted reserves, structure, res densities
%% S1 S2 P1 P2 E1 E2 V m1 m2






