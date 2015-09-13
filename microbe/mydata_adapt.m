%% script-file to illustrate the use of adapt.m
%%   which specifies the module for adaptation and inhibition
%% special case: 2 substrates, 4 cultures

%% Data from Kompala, D, S., Ramkrishna, D., Jansen, N. B. and Tsao, G. T.
%%  1986 Investigation of bacterial growth on mixed substrates:
%%  experimental evaluation of cybernetic models.
%%  Biotech & Bioeng 28: 1044 - 1056

%% Klebsiella oxytoca on glucose, precultured on glucose
%%   time in h, biomass in g/l
Glu =  [0.4904   0.0109;
        0.9953   0.0155;
        1.5000   0.0229;
        1.9827   0.0375;
        2.4872   0.0664;
        2.9808   0.1132;
        3.4744   0.1904;
        3.9680   0.3203;
        4.4726   0.5530;
        4.9771   1.0056;
        5.4705   1.8285;
        5.9642   2.9203;
        6.4586   3.0007;
        6.9642   2.9655];

%% Klebsiella oxytoca on xylose, precultured on glucose
%%   time in h, biomass in g/l
Xyl =  [0.2507   0.0049;
        0.7341   0.0074;
        1.2449   0.0100;
        1.7419   0.0136;
        2.2389   0.0176;
        2.7360   0.0257;
        3.1366   0.0360;
        3.7164   0.0518;
        4.2273   0.0756;
        4.7245   0.1089;
        5.2079   0.1673;
        5.6913   0.2505;
        6.2022   0.3801;
        6.6994   0.5842;
        7.1966   0.8302;
        7.6799   1.1647;
        8.1908   1.7441;
        8.7015   2.2041;
        9.1981   2.2906];

%% Klebsiella oxytoca on 0.5 g/l glucose and 2.5 g/l xylose
%%   precultured on glucose;  time in h, biomass in g/l
GluXyl=[0.2470   0.0038;
        0.7272   0.0084;
        1.2485   0.0142;
        1.7287   0.0238;
        2.2088   0.0395;
        2.7027   0.0673;
        3.1005   0.1074;
        3.6767   0.1782;
        4.1843   0.2372;
        4.4175   0.2597;
        4.6644   0.2666;
        4.9250   0.2844;
        5.1857   0.3075;
        5.6658   0.4255;
        6.2008   0.6042;
        6.6947   0.8146;
        7.1885   1.1719;
        7.6823   1.5799;
        8.1899   1.7302;
        8.6837   1.7078];

%% Klebsiella oxytoca on 0.33 g/l glucose and 2.0 g/l xylose
%%   precultured on glucose; time in h, biomass in g/l
XylGlu=[0  	 0.0440;
        0.3324   0.0521;
        0.6586   0.0746;
        0.9933   0.0996;
        1.3279   0.1370;
        1.6457   0.1941;
        1.9892   0.2104;
        2.3075   0.2191;
        2.6426   0.2327;
        2.9692   0.2677;
        3.4713   0.3871;
        3.9735   0.5655;
        4.5593   0.8596;
        4.9695   1.1031;
        5.7404   1.1387];

%% set parameters
  KA = 0.01;    %  1 g/l, saturation constant for substr A
  KAB = 1e8;    %  2 g/l, inhibition constant for A on B
  KB = 0.2;     %  3 g/l, saturation constant for substr B
  KBA = 1e8;    %  4 g/l, inhibition constant for B on A
  jAm = 18.71;  %  5 g/(g.l.h), max spec uptake rate for substr A
  jBm = 22.95;  %  6 g/(g.l.h), max spec uptake rate for substr B
  kapA0 = 0;    %  7 -, rel background expression for substr A
  kapB0 = 0;    %  8 -, rel background expression for substr B
  pA = 0.71;    %  9 -, preference parameter for substr A; pB = 1 - pA
  h = 0.80;     % 10 1/h, carrier turnover rate
  kE = 0.5;     % 11 1/h, reserve turnover rate
  kM = 0;       % 12 1/h, maintenance rate coefficient
  yAE = 0.9;    % 13 g/g, yield of substr A on reserves
  yBE = 0.6;    % 14 g/g, yield of substr B on reserves
  yEV = 1.2;    % 15 g/g, yield of reserve on structure
  %% Now follow initial conditions for cultures 1-4
  A10 = 5.8;    % 16 g/l, substr A in cult 1 at time 0
  B10 = 0;      % 17 g/l, substr B in cult 1 at time 0
  V10 = 0.018;  % 18 g/l, biomass in cult 1 at time 0
  m10 = jAm/kE; % 19 g/g, res density in cult 1 at time 0
  kapA10 = 0.9; % 20 -, expression for substr A at time 0
  A20 = 0;      % 21 g/l, substr A in cult 2 at time 0
  B20 = 4.7;    % 22 g/l, substr B in cult 2 at time 0
  V20 = 0.015;  % 23 g/l, biomass in cult 2 at time 0
  m20 = jAm/kE; % 24 g/l, res density in cult 2 at time 0
  kapA20 = 0.9; % 25 -, expression for substr A at time 0
  A30 = 0.5;    % 26 g/l, substr A in cult 3 at time 0
  B30 = 2.5;    % 27 g/l, substr B in cult 3 at time 0
  V30 = 0.015;  % 28 g/l, biomass in cult 3 at time 0
  m30 = jAm/kE; % 29 g/g, res density in cult 3 at time 0
  kapA30 = 0.9; % 30 -, expression for substr A at time 0
  A40 = 0.33;   % 31 g/l, substr A in cult 4 at time 0
  B40 = 2.0;    % 32 g/l, substr B in cult 4 at time 0
  V40 = 0.015;  % 33 g/l, biomass in cult 4 at time 0
  m40 = jAm/kE; % 34 g/g, res density in cult 4 at time 0
  kapA40 = 0.9; % 35 -, expression for substr A at time 0
  %% it seems to be reasonable in this case to give the
  %%   inoculum of each culture the same reserve density,
  %%   as well as the same initial expression. Gain: 6 pars
  %% parameter setting such that inhibition and background expression
  %%   are disabled; no maintenance. Gain: 5 pars

  %% collect parameters in vector
  p = [KA, KAB, KB, KBA, jAm, jBm, kapA0, kapB0, pA, h, ... % uptake
       kE, kM, yAE yBE, yEV, ... % energetics
       A10, B10, V10, m10, kapA10, A20, B20, V20, m20, kapA20, ... % init
       A30, B30, V30, m30, kapA30, A40, B40, V40, m40, kapA40]';   % init

  %% estimate parameters
  p = [p, zeros(35,1)]; % keep all parameters fixed
  p([1 3 5 6 9 10 11 13 14 18 19 23 28 33], 2) = 1;
				% estimate these parameter numbers
  p = nmregr('adapt', p, Glu, Xyl, GluXyl, XylGlu);

  shregr_options('xlabel', 1, 'time, h');
  shregr_options('xlabel', 2, 'time, h');
  shregr_options('xlabel', 3, 'time, h');
  shregr_options('xlabel', 4, 'time, h');
  shregr_options('ylabel', 1, 'biomass, g/l');
  shregr_options('ylabel', 2, 'biomass, g/l');
  shregr_options('ylabel', 3, 'biomass, g/l');
  shregr_options('ylabel', 4, 'biomass, g/l');
  shregr('adapt', p, Glu, Xyl, GluXyl, XylGlu);
