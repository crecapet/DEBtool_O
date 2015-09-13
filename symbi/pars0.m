%% Parameters for "endosym"
%%   2 interacting species each having 1 structure (V) and 1 reserve (E)
%%   each species eats one substrate (S) and one product
%%   substrates and productes are substitutable
%% Control-parameters:
%%   hazard rates h1_V, h2_V, h1_S, h2_S, h1_P, h2_P or h
%%   supply fluxes J1_Sr, J2_Sr or supply concentrations S1_r, S2_r

global h1_V h2_V h1_S h2_S h1_P h2_P h ... % reactor drains
    J1_Sr J2_Sr S1_r S2_r ... % reactor feeding
    k1_E k2_E k1_M k2_M ...
    k1_S k2_S k1_P k2_P ...
    b1_S b2_S b1_P b2_P ...
    y1_EV y2_EV y1_ES y2_ES y1_EP y2_EP ...
    y1_PS y2_PS y1_PP y2_PP y1_PM y2_PM y1_PG y2_PG ...
    istate0

h = 0.002;                       % spec throughput rate of the chemostat
S1_r = 100; S2_r = 200;          % conc substrate in feed 
h1_V=h;h2_V=h;h1_S=h;h2_S=h;h1_P=h;h2_P=h; % hazard rates equal to throughput rate  
J1_Sr = h*S1_r; J2_Sr = h*S2_r;  % supply fluxes from supply concentrations

k1_E = 2.5; k2_E = 3.0;       % reserve-turnover rate
k1_M = 0.002; k2_M = 0.004;   % maintenance rate coeff
k1_S  = 0.3; k2_S  = 0.4;     % dissociation rate
k1_P  = 1.7; k2_P  = 1.5;     % dissociation rate

b1_S = 1.2; b2_S = 1.2;       % uptake of substrate
b1_P = 0.2; b2_P = 0.2;       % uptake of product

y1_EV = 1.2; y2_EV = 1.2; % yield of E on V (>1 since E -> V)
y1_ES = 0.7; y2_ES = 0.7; % yield of E on S 
y1_EP = 0.7; y2_EP = 0.7; % yield of E on P 

y1_PS = 0.2; y2_PS = 0.2; % yield of P on S-assimilation
y1_PP = 0.2; y2_PP = 0.2; % yield of P on P-assimilation
y1_PM = 0.6; y2_PM = 0.6; % yield of P on maintenance
y1_PG = 0.0; y2_PG = 0.0; % yield of P on growth

istate0 = [S1_r S2_r 1 1.1 11 1.2 12 1.3]; % initial state values (8)
%% substrates, products, structure, res density, structure, res density
%% S1 S2 P1 P2 V1 m1 V2 m2
