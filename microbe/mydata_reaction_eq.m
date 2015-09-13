%% microchemical reaction equations
%% 1 heterotrophy (glycerol)
%% 2 type I methanotrophy
%% 3 type II methanotrophy
%% 4 anammox

switch 2 % modify this number to choose for one of the cases 

  case 1 % Heterotrophy: Kleibsiella living on glycerol at 35 C {134}
    %% glycerol C3H8O3 -> CH2.666O is energy and carbon substrate

    %% composition
    nHX = 8/3;  nOX = 1   ; nNX = 0;    % substrate (glycerol)
    nHE = 1.66; nOE = .422; nNE = .312; % reserve
    nHV = 1.64; nOV = .379; nNV = .198; % structure

    %%   X   S   E   V      E-substr, C-substr, reserve, structure
    n = [1   1   1   1;   % C CO2
         nHX nHX nHE nHV; % H H2O
         nOX nOX nOE nOV; % O O2
         nNX nNX nNE nNV];% N NH3

    jEAm = 2.3341; % mol/mol.h, spec max assim flux
    %% rather arbitrary to give energy investment ratio  g = 1
    kE = 2.11;  % 1/h, reserve turnover
    kM = 0.021; % 1/h, maint rate coeff
    yXE = 1.345; yEX = 1/yXE; % mol/mol SousMota2006; yXE = 1.490 in Kooy2000
    yVE = 0.904; yEV = 1/yVE; % mol/mol SousMota2006; yVE = 1.135 in Kooy2000
    rm = (jEAm - kM * yEV)/ (jEAm/ kE + yEV);  % 1/h max spec growth rate

    nr = 100; r = linspace(0,rm,nr); % spec growth rates

    Y = yield(n); % cols: Ac Aa M Gc Ga; rows: C H O N X S E V
    j = Y * flux_5(r, [yEX yVE jEAm kE kM])'; % fluxes of C H O N X S E V
    mE = yEV * (r + kM) ./ (kE - r); % reserve density
    r = r/ rm; % scaled spec growth rates (for plotting)

  case 2 % Type I methanotrophy: CH4 is energy and carbon source
    %% Methylomonas, Methylomicrobium, Methylobacter, Methyloccus
    
    %% composition
    nHX = 4;   nOX = 0;  nNX = 0;  % methane
    nHE = 1.8; nOE = .3; nNE = .3; % reserve
    nHV = 1.8; nOV = .5; nNV = .1; % structure

    %%   X   S   E   V      E-substr, C-substr, reserve, structure
    n = [1   1   1   1;   % C CO2
         nHX nHX nHE nHV; % H H2O
         nOX nOX nOE nOV; % O O2
         nNX nNX nNE nNV];% N NH3

    jEAm = 1.2; % mol/(mol.h)
    kE = 2;     % 1/h
    kM = .01;   % 1/h
    yEX = 0.8; yXE = 1/yEX; % mol/mol
    yVE = 0.8; yEV = 1/yVE; % mol/mol

    jEM = yEV * kM;
    rm = (jEAm - jEM)/ (jEAm/ kE + yEV);

    nr = 100; r = linspace(0,rm,nr);

    Y = yield(n); % cols: Ac Aa M Gc Ga; rows: C H O N X S E V
    j = Y * flux_5(r, [yEX yVE jEAm kE kM])'; % fluxes of C H O N X S E V
    mE = yEV * (r + kM) ./ (kE - r); % reserve density
    r = r/ rm; % scaled spec growth rates (for plotting)

  case 3 % Type II methanotrophy: CH4 and CO2 are carbon source
    %% Methylosinus, Methylocystis,

  otherwise
    return;
end

%% plotting %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% gset term postscript color solid 'Times-Roman' 30

subplot(1,3,1)
  % gset xrange[*:*] % [0:1]
  % gset yrange[*:*] % [-3:1]
  %% gset xtics .2
  %% gset ytics 1
  %% gset key .3,-1.75
  %% gset output 'heterotrophy_1.ps'
  xlabel('scaled growth rate')
  ylabel('flux, mol/mol.h')
  plot(r, j(5,:), '.m;;', ...X
       r, j(5,:) + j(6,:), 'm;j_X;', ... % X + S
       r, j(1,:), 'k;j_C;', ... %C
       r, j(3,:), 'r;j_O;', ... %O
       r, j(4,:), 'b;j_N;', ... %N
       r, j(7,:), 'g;j_E;', ... %E
       [0;1], [0;0], 'k;;')

subplot(1,3,2)
  %% gset key .6,1.5
  %% gset output 'heterotrophy_2.ps'
  xlabel('scaled growth rate')
  ylabel('flux ratio, mol/mol')
  plot(r, (j(5,:) + j(6,:))./j(3,:), 'm;j_X/j_O;', ... % X/O
       r, j(4,:)./j(3,:), 'b;j_N/j_O;', ... % N/O
       r, j(1,:)./j(3,:), 'k;j_C/j_O;', ... % C/O
       [0;1], [0;0],'k;;')

subplot(1,3,3)
  %% gset yrange[0:.8]
  %% gset ytics .2
  %% gset key .6,.75
  %% gset output 'heterotrophy_3.ps'
  xlabel('scaled growth rate')
  ylabel('biomass specific flux, mol/mol.h')
  plot(r, -j(3,:)./(1 + mE), 'r;J_O/M_W;', ... % O/W
       r,  j(1,:)./(1 + mE), 'k;J_C/M_W;') ... % C/W
