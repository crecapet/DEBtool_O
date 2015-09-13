%% fig:plantcurve
%% out:plant

%% plant growth, see domain plant for more details
    
pars; %% edit parameter values in /debtool/plant/pars.m

%% gset output "plant.ps"

shregr2_options('default')
shtime (1)

hold on;
X(1) = .0025; % reduce light from 5 to .0025
shregr2_options('default')
shtime(1)
