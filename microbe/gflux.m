function fXN = gflux (X, N, s)
  %% X: (nX,1)-vector with concentrations of CH4 (mM)
  %% N: (nN,1)-vector with concentrations of NH3 (mM)
  %% s: scalar with number of the selected compound: i = 1,2 ..,7
  %% flux: flux of X, C, H, O, N, E or V
  global jEAm KX KN kM kE yVE yEX Y
  
  %% biomass concentration
  MV = 1;
  nX = max(size(X)); nN = max(size(N)); fXN = zeros(nX,nN);
  for i=1:nX
    for j = 1:nN
      
      MX = X(i); MN = N(j); % set concentrations of CH4 and NH3
      
      %% reserve fluxes
      jEA = jEAm*(1 + KX/MX + KN/MN - 1/(MX/KX + MN/KN))^(-1); % assim of E
      jEM = kM/ yVE; % flux of E in association with maintenance
      mE = jEA/kE;   % reserve density at steady state
      jEG = (kE * mE - jEM)/(mE + 1/ yVE);
				% flux of E in assoc with growth (total)

      %% concentrations of compounds
      M = [MX; inf; inf; inf; MN; mE*MV; MV]; % mass of X, C, H, O, N, E, V

      %% process rates, decomposed to: AC, AA, M, GC, GA
      k  = MV * [(1-1/yEX)*jEA; jEA; jEM; (1 - yVE) * jEG; yVE * jEG];

      %% fluxes of compounds (vector-valued reaction rate)
      flux = Y*k; % flux of X, C, H, O, N, E, V

      fXN(i,j) = flux(s);
    end
  end
