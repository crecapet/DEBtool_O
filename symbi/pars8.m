%% Parameters for "endosym"
%%   single species having 1 structure (V) and 1 reserve (E)
%%
%% Control-parameters:
%%   hazard rates h_V, h1_S, h2_S, h1_P, h2_P or h
%%   supply fluxes J1_Sr J2_Sr or supply concentration S1_r S2_r

global h_V h1_S h2_S h1_P h2_P ... % reactor drains
      J1_Sr J2_Sr S1_r S2_r ... % reactor feeding
      k_E k_M ... % res turnover, maintenance
      k ... % max assimilation
      b1_S b2_S ... % uptake rates
      y_EV y1_es y2_es y12_PE y21_PE ...
      y1_PE y2_PE y1_PM y2_PM y1_PG y2_PG ... % product yields
      istate8 % initial values of state variables (set here in pars8)
    

h = 0.002;                       % spec throughput rate of the chemostat
S1_r = 100; S2_r = 200;        % conc substrate in feed 
h_V = h; h1_S = h; h2_S = h; h1_P = h; h2_P = h; % hazard rates equal to throughput rate  
J1_Sr = h*S1_r; J2_Sr = h*S2_r;% supply flux from supply concentration

k_E = 3;     % reserve-turnover rate
k_M = 0.01;  % maintenance rate coeff
k = 0.7;     % max assimilation rate

b1_S = 0.1; b2_S = 0.1; % uptake of substrate

y_EV = 1.2;                         % yield of E on V (>1 since E -> V)
y1_es = 0.9/0.7; y2_es = 0.9/0.7;   % yield of E on S1 and S2 

y12_PE = 0.2; y21_PE = 0.2; % yield of P on E

y1_PE = 2; y2_PE = 2; % yield of P on assimilation
y1_PM = 0.6; y2_PM = 0.6; % yield of P on maintenance
y1_PG = 0.0; y2_PG = 0.0; % yield of P on growth

istate8 = [S1_r S2_r 0.01 0.02 .1 1]; % initial state values (6)
%% substrates, products, structure, res density
%% S1, S2, P1, P2, V, m
