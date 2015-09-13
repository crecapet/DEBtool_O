function shstate0a (j)
  %% shstate0a (j)
  %% created: 2001/11/06 by Bas Kooijman, modified 2009/02/20
  %% chemostat equilibrium plots for 'endosym'
  %% State vector:
  %% (1-2)substrates S (3-4)products P
  %% (5,6)structure V, reserve density m of species 1
  %% (7,8)structure V, reserve density m of species 2 (external)

  global h S1_r S2_r ... % reactor controls
      k1_E k2_E k1_M k2_M ... % res turnover, maintenance rate coeff
      k1_S k2_S k1_P k2_P ... % dissociation rates
      b1_S b2_S b1_P b2_P ... % association rates
      y1_EV y2_EV y1_ES y2_ES y1_EP y2_EP ... % res, substr, prod costs
      y1_PS y2_PS y1_PP y2_PP y1_PM y2_PM y1_PG y2_PG % product yields
  global istate0

  pars_endosym; % set parameter values

  %% first find max growth rate for both species
  j1_E = y1_ES*k1; % max assim 
  m1 = j1_E/k1_E; % max res density 1
  r1 = (k1_E*m1 - k1_M*y1_EV)/(m1 + y1_EV); % max spec growth rate

  j2_E = y2_ES*k2; % max assim 
  m2 = j2_E/k2_E; % max res density 2
  r2 = (k2_E*m2 - k2_M*y2_EV)/(m2 + y2_EV); % max spec growth rate

  r = min(r1,r2); % max spec growth rate
  nh = 100; % number of throughput rates
  dh = r/nh; % increment in throughput rates
  H = linspace(1e-4,r,nh); % set thoughput rates
  X = zeros(nh,8); % initiate state matrix
  
  i = 20; % set initial counter
  h = H(i); h1S = h; h2S = h; h1P = h; h2P = h; h1V = h; h2V = h;
  J1_Sr = S1_r*h; J2_Sr = S2_r*h;
  X_t  = lsode ('dstate0', istate0, [0,300]);
  X(i,:) = fsolve('dstate0',X_t(2,:)')';

  for k = 1:(i-1) % from initial throughput down to zero
    h = H(i-k); h1S = h; h2S = h; h1P = h; h2P = h; h1V = h; h2V = h; 
   J1_Sr = S1_r*h; J2_Sr = S2_r*h;
    X(i-k,:) = fsolve('dstate0',X(i-k+1,:)')';
  end
  while X(i,8)>0 && i<nh % from initial throughput up to max throughput
    i = i+1;
    h = H(i); h1S = h; h2S = h; h1P = h; h2P = h; h1V = h; h2V = h; 
    J1_Sr = S1_r*h; J2_Sr = S2_r*h;
    X(i,:) = fsolve('dstate0',X(i-1,:)')';
  end
  X = X(1:(i-1),:); % remove throughput rates with washout
  H = H(1:(i-1))';
  
  clf
  
  if exist('j', 'var')==1 % single plot mode
    switch j
	
      case 1
        xlabel('throughput rate'); ylabel('substrates'); 
        plot (H, X(:,1), 'b', H, X(:,2), 'r');

      case 4
        xlabel('throughput rate'); ylabel('products');
        plot (H, X(:,3), 'b', H, X(:,4), 'r');

      case 2
        xlabel('throughput rate'); ylabel('structures');
        plot (H, X(:,5), 'b', H, X(:,7), 'r');

      case 3
        xlabel('throughput rate'); ylabel('res densities');
        plot (H, X(:,6), 'b',H, X(:,8), 'r');

      case 5
        xlabel('throughput rate'); ylabel('ratio structure 2/1');
        plot (H, X(:,7)./X(:,5), 'g');

      case 6
	xlabel('throughput rate'); ylabel('ratio res density 2/1');
        plot (H, X(:,8)./X(:,6), 'g');

      otherwise
	return;

    end
  else % multiple plot mode
    
        subplot (2, 3, 1); clf;
        xlabel('throughput rate'); ylabel('substrates'); 
        plot (H, X(:,1), 'b', H, X(:,2), 'r');

        subplot (2, 3, 4); clf;
        xlabel('throughput rate'); ylabel('products'); 
        plot (H, X(:,3), 'b', H, X(:,4), 'r');

        subplot (2, 3, 2); clf;
        xlabel('throughput rate'); ylabel('structures');
        plot (H, X(:,5), 'b', H, X(:,7), 'r');

        subplot (2, 3, 3); clf;
        xlabel('throughput rate'); ylabel('res densities');
        plot (H, X(:,6), 'b', H, X(:,8), 'r');

        subplot (2, 3, 5); clf;
        xlabel('throughput rate'); ylabel('ratio structure 2/1');
        plot (H, X(:,7)./X(:,5), 'g');

        subplot (2, 3, 6); clf;
	    xlabel('throughput rate'); ylabel('ratio res density 2/1');
        plot (H, X(:,8)./X(:,6), 'g');

  end