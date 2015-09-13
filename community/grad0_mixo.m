function X_t = grad0_mixo
  %% X_t = grad0_mixo
  %% created: 2002/03/17 by Bas Kooijman
  %% calculates vertical gradient ontogeny: 0 reserves
  %% X_t: (nt,nL*4) matrix with values of state variables (in columns)
  %%   as function of time (in rows) and depth (in columns)
  %%   no downward transport from bottum layer (closed stack)
  %%   light reduction factor constant per layer

  global istate; % initial states 
  global nL nX j_L_F J_L_F;

  pars0_mixo; % set parameter values
  J_L_F = j_L_F; % copy light intensity into dummy
  nL = 25; L = linspace(0, -nL, nL); %% number of layers, depth
  nX = max(size(istate)); % number of state variables per layer
  X0 = zeros(nL*nX,1);    % initiate initial state
  
  %% start with homogeneous gradient at time = 0
  %% catenate state variables in all layers
  for i = 1:nL
    X0((i-1)*nX + (1:nX)) = istate;
  end
  
  
  tmax = 150; nt = 100; t = linspace (0, tmax, nt); % set time points
  X_t  = lsode ('dgrad0_mixo', X0, t);
