%% Potassium limited growth of E. coli at 30C in a batch culture
%% Data from M.M. Mulder 1988 (PhD thesis)
%% See DEB-book, page 319

%% Time, h; Potassium, mM; weight coefficients
muld88a = [0.015 0.921 0.416 1.43 1.683 1.199 1.974 2.449 2.745 2.968 ...
	   3.218 3.706 4.965 6.247 7.482 8.733 9.512; ...
	   0.8 0.809 0.761 0.699 0.619 0.582 0.48 0.332 0.212 0.124 ...
	   0 0 0 0 0 0 0; ...
	   1 1 1 1 1 1 10 10 10 10 10 10 10 10 10 10 10]';

%% Time, h; Extinction at 540 nm; weight coefficients
muld88b = [0 0.25 0.5 0.75 1 1.25 1.5 1.75 2 2.5 2.75 3 3.25 3.5 3.75 4 ...
	   4.25 4.5 4.75 5 5.25 5.5 5.75 6 6.25 6.5 6.75 7 7.25 7.5 ...
	   7.75 8 8.25 8.5 8.75 9 9.25 9.5; ...
	   0.47 0.565 0.616 0.682 0.748 0.904 1.046 1.278 1.496 2.99 ...
	   3.662 4.484 5.626 7.356 8.406 9.184 9.599 10.526 10.85 11.733 ...
	   12.148 12.249 12.663 13.258 14.198 14.795 15.369 15.434 15.743 ...
	   15.495 15.486 16.036 16.905 15.532 16.309 17.571 17.032 ...
	   17.294; ...
	   0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 ...
	   0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 ...
	   0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1]';


%% Parameters
N0  = 0.8248; % mM, initial potassium conc
X0  = 0.6566; % OD, initial biomass
jNm = 0.1249; % mM/(h.OD) max spec uptake rate
g   = 0.4262; % -, investment ratio
kE  = 0.9247; % 1/h, reserve turnover
pars = [N0; X0; jNm; g; kE];

function [Nt, Xt] = batch (p, tN, tX)
  %% Nutrient limited batch culture (maintenance negligibly small)
  %% p: (1) mM, initial potassium conc
  %%    (2) OD, initial biomass
  %%    (3) mM/(h.OD) max spec uptake rate
  %%    (4) -, investment ratio
  %%    (5) 1/h, reserve turnover
  %% tN: (ntN,3)-matrix with times in tN(:,1) for nutrient conc
  %% tX: (ntX,3)-matrix with times in tX(:,1) for biomass density
  %% Nt: (ntN,1)-matrix with nutrient concentrations
  %% Xt: (ntX,1)-matrix with biomass densities

  %% unpack parameter vector
  N0 = p(1); X0 = p(2); jNm = p(3); g = p(4); kE = p(5);

  r = kE/(1+g); % max spec growth rate
  T = log(1 + r*N0/(X0*jNm))/r; % time at nutrient depletion
  XT = X0*e^(T*r); % biomass at T
  Xt = (tX(:,1)<=T)*X0.*e.^(tX(:,1)*r) + ...          %% biomass before T
      (tX(:,1)>T).*XT.*(g+1)./(g+e.^(kE*(T-tX(:,1))));%% biomass after T
  Nt = max(0,N0*(e^(r*T)-e.^(tN(:,1)*r))/(e^(r*T)-1));%% nutrient
endfunction

pars = nrregr('batch', pars, muld88a, muld88b);
[cov, cor, sd] = pregr('batch', pars, muld88a, muld88b);
[pars, sd]
shregr_options('default')
shregr_options('xlabel', 1, 'time, h')
shregr_options('ylabel', 1, 'potassium, mM')
shregr_options('xlabel', 2, 'time, h')
shregr_options('ylabel', 2, 'E.coli, OD at 540 nm')

shregr('batch', pars, muld88a, muld88b)