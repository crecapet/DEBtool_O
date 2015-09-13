%% C,N,P-limited algal growth in a batch culture
%% Bas Kooijman, modified 2009/02/20
%% Nannochloropsis gaditana; Temp 20 C; pH 8.3; f/2 medium
%% Data by Carmen Garrido Perez 2001/09/16; 

%% The background to these data can be found in:
%% S. A. L. M. Kooijman, C. Garrido Perez, and J. A. Perales Vargas-Machuca
%% Modeling simultaneous nutrient limitations in algal batch
%%   cultures using synthesizing units
%% Ecol Letters, 2003, in prep.

%% 9 time points in hours
    time = [0 24 48 72 96 120 168 216 264]';

%% 19 Nitrate and phospate combinations in mg/l
    NP = [24.724  1.985; %  1  N,P decreasing simulatenously
	  8.241   0.662; %  2  N/P ratio fixed 
	  2.747   0.221; %  3
	  0.916   0.074; %  4 
	  0.305   0.025; %  5 
	  0.102   0.008; %  6 
	  0.034   0.003; %  7 
	  24.724  0.662; %  8  N constant, P decreasing
	  24.724  0.221; %  9 
	  24.724  0.074; % 10 
	  24.724  0.025; % 11 
	  24.724  0.008; % 12 
	  24.724  0.003; % 13  
	  8.241   1.985; % 14  P constant, N decreasing
	  2.747   1.985; % 15 
	  0.916   1.985; % 16 
	  0.305   1.985; % 17 
	  0.102   1.985; % 18 
	  0.034   1.985];% 19
    NP(:,1) = NP(:,1)*1000/14; NP(:,2) = NP(:,2)*1000/31; % conc in muM
    %% select =[1 14 15 16 17 18 19]; NP = NP(select,:);
    %% select =1; NP = NP(select,:);
	   
%%  (9,19)-matrix with Optical Densities
    %%  biomass in OD; notice transpose): 1 OD = 12.7 mM C
    %%  0.23 OD = 10^7 cells/ml = 1.5 $\mu$g chl/ml = 2.35 mM C
%%  time in dim 1 (rows), N,P-combinations in dim 2 (columns)

    OD=[0.229 0.291 0.425 0.611 0.754 0.894 1.004 1.140 1.242; % N,P reduc. 
        0.226 0.281 0.420 0.590 0.717 0.845 0.935 1.057 1.137;
        0.227 0.293 0.434 0.569 0.671 0.734 0.780 0.889 0.977;
        0.227 0.285 0.399 0.451 0.494 0.556 0.609 0.694 0.753;
        0.231 0.291 0.361 0.404 0.419 0.440 0.464 0.516 0.551;
        0.223 0.269 0.331 0.385 0.414 0.453 0.472 0.517 0.518;
        0.222 0.267 0.320 0.373 0.406 0.432 0.453 0.492 0.508;
        0.241 0.296 0.421 0.583 0.714 0.845 0.952 1.094 1.221; % P reductions
        0.232 0.292 0.431 0.591 0.728 0.851 0.960 1.119 1.227;
        0.229 0.286 0.423 0.563 0.696 0.806 0.889 1.035 1.151;
        0.232 0.288 0.417 0.553 0.677 0.780 0.865 0.982 1.100;
        0.223 0.285 0.418 0.546 0.668 0.767 0.849 0.968 1.080;
        0.224 0.292 0.423 0.555 0.679 0.779 0.860 0.978 1.085; 
        0.246 0.308 0.439 0.605 0.726 0.858 0.966 1.092 1.213; % N reductions
        0.212 0.273 0.416 0.546 0.642 0.719 0.782 0.907 0.970;
        0.226 0.284 0.405 0.459 0.513 0.587 0.646 0.738 0.798;
        0.233 0.291 0.366 0.396 0.395 0.403 0.419 0.463 0.502;
        0.233 0.277 0.335 0.383 0.405 0.427 0.447 0.490 0.528;
        0.237 0.283 0.331 0.376 0.400 0.422 0.439 0.471 0.498]';
  %%  OD = OD(:,select);

  %% parameters for mydata_cnplim ...
  %% simultaneous growth limitation by C, N and P
  %% p: (21,2) parameter matrix, see below
  
  %% saturation parameters
  K_C = 0.04;    % mM, half-saturation concentration for uptake of CO2
  K_N = 59.559;  % muM, half-saturation concentration for uptake of nitrogen
  K_N = 558.14;  % muM, half-saturation concentration for uptake of nitrogen
  K_P = 1106.1;  % muM, half-saturation concentration for uptake of phosphorous
  K_P = 15347;  % muM, half-saturation concentration for uptake of phosphorous
  
  %% max specific uptake parameters
  j_Cm = 0.05281;    % mmol/mol.h, max spec C-res assimilation
  j_Cm = 0.02644;    % mmol/mol.h, max spec C-res assimilation
  j_Nm = 2.1374;     % mumol/mol.h, max spec N-res assimilation
  j_Nm = 4.969;      % mumol/mol.h, max spec N-res assimilation
  j_Pm = 0.26162;    % mumol/mol.h, max spec P-res assimilation
  j_Pm = 0.62811;    % mumol/mol.h, max spec P-res assimilation
  
  %% reserve parameter
  k_E  = 0.04684;    % 1/h, reserve turnover rate
  k_E  = 0.06165;    % 1/h, reserve turnover rate

  %% excretion fractions (1 - kappa_*)
  kap_C = 0;  % -, return fraction for C
  kap_N = 0;  % -, return fraction for N
  kap_P = 0;  % -, return fraction for P
  
  %% yield coefficients      
  yC_EV = 1.2;        % mmol/mol, from C-reserve to structure
  %% yC_EV = 0.1219;        % mmol/mol, from C-reserve to structure
  yN_EV = 77.1919;     % mumol/mol, from N-reserve to structure
  yN_EV = 71.589;      % mumol/mol, from N-reserve to structure
  %% yN_EV = 200;     % mumol/mol, from N-reserve to structure
  yP_EV = 0.51069;      % mumol/mol, from p-reserve to structure
  yP_EV = 0.20384;      % mumol/mol, from p-reserve to structure
  %% yP_EV = 13;      % mumol/mol, from p-reserve to structure
  
  %% Carbon exchange rates with air
  J_C0 = 0.01181;     % mmol/h, import DIC flux from air to culture
  J_C0 = 0.013637;     % mmol/h, import DIC flux from air to culture
  J_N0 = 0*0.36934;     % mumol/h, import DIN flux from air to culture
  %% J_N0 = 0*0.37108;     % mumol/h, import DIN flux from air to culture
  %% specific export rate equals J_C0/C_0

  %% control parameters
  C_0 = 1.91572;        % mM, intital DIC conc.
  %% 1.89534;           % mM, initial bicarbonate conc.
  %% 0.02038;           % mM, initial CO2 concentration
  C_0 = 2.0254;         % mM, intital DIC conc.

  X_0 = 1.2862;          % mM, initial structure concentration
  X_0 = 1.1282;          % mM, initial structure concentration

  %% these are not used, but dynamically set to these values
  m_C0 = j_Cm/k_E; % mmol/mol, initial C-reserve density
  m_N0 = j_Nm/k_E; % mumol/mol, initial N-reserve density
  m_P0 = j_Pm/k_E; % mumol/mol, initial P-reserve density

  ymMOD = 12.7;  % conversion from OD to mM
  ymMOD = 7.165; % conversion from OD to mM

  %% eerste msd: 0.000782615
  %% tweede msd: 0.001097
  
  %% collect parameters in a vector
  p = zeros(21,1);
  p(1) =   K_C; p(2) =  K_N; p(3) =  K_P; p(4) = j_Cm; p(5) = j_Nm;
  p(6) =  j_Pm; p(7) =  k_E; p(8) =kap_C; p(9) =kap_N; p(10)=kap_P;
  p(11)= yC_EV; p(12)=yN_EV; p(13)=yP_EV; p(14)= J_C0; p(15)= J_N0;
  p(16)=   C_0; p(17)=  X_0; p(18)= m_C0; p(19)= m_N0; p(20)= m_P0;
  p(21)= ymMOD;

  %% fix all parameters during estimation
  p = [p, zeros(21,1)];
  %% p([1 2 3 4 5 6 7 11 12 13 14 16],2) = 1;
  p([2 3 4 5 6 7 12 13 14 15 16 17 21],2) = 1;

  %% improve parameter estimates
  nmregr_options('max_step_nr',800);
  p = nmregr2('cnplim', p, time, NP, OD);
  
  %% show data and model predictions
  shregr2_options('plotnr',1);
  shregr2_options('xlabel', 'time, h');
  shregr2_options('zlabel', 'OD');
  %% select = [1 8 19]; % select only these data-set-numbers for plotting
  %% shregr2 ('cnplim', p, time, NP, OD);
  %% shregr2 ('cnplim', p, time, NP(select,:), OD(:,select));
  %% return

  subplot(1,3,1)
   select = 1:7; % select only these data-set-numbers for plotting
    shregr2 ('cnplim', p, time, NP(select,:), OD(:,select));
   subplot(1,3,2)
    select = [1, 8:13]; % select only these data-set-numbers for plotting
    shregr2 ('cnplim', p, time, NP(select,:), OD(:,select));
   subplot(1,3,3)
    select = [1, 14:19]; % select only these data-set-numbers for plotting
    shregr2 ('cnplim', p, time, NP(select,:), OD(:,select));

  %% return
  
  [cov cor sd] = pregr2('cnplim', p, time, NP, OD);
  [p, sd] % present estimates and sd

  [Ct, Nt , Pt, ECt, ENt, EPt, Vt] = cnpt(p,time,NP);
  %% Ct DIC, Nt nitrate, Pt phosphate
  %% ECt, ENt, EPt: C,N and P reserves (absolute); Vt structure
  %% Bt + Ct + ECt + Vt % total carbon (must be constant)

  %% (ECt + Vt)./(Ct + ECt + Vt) % fraction of C in organic carbon
  %% (ECt + Vt - ECt(1,1) - Vt(1,1))./ ...
  %%   (Ct + ECt + Vt - ECt(1,1) - Vt(1,1))
  %%   fraction of DIC that becomes organic carbon

  %% Ct./(p(1,1)+Ct) % functional response for DIC
  %% Nt./(p(2,1)+Nt) % functional response for N
  %% Pt./(p(3,1)+Pt) % functional response for P

  %% Nt + ENt + p(12,1)*Vt % total nitrogen (must be constant)
  %% Pt + EPt + p(13,1)*Vt % total phosphorus (must be constant)
