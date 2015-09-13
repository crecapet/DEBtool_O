function shstate7 (j)
  %% shstate7 (j)
  %% created: 2002/04/01 by Bas Kooijman, modified 2009/02/20
  %% chemostat equilibrium plots for "endosym"
  %% State vector:
  %% (1-2)substrates S (3-4)products P (5-7)excreted reserves E
  %% (7-9)structure V, reserve densities 1, 2

  global h S1_r S2_r ... % reactor setting
      k1_E k2_E k1_M k2_M ... % res turnover, maintenance
      k1 k2 ... % max assimilation
      b1_S b2_S kap1 kap2 ... % uptake rates, recovery fractions
      y1_EV y2_EV y1_es y2_es y12_PE y21_PE ... % costs for structure, reserves
      y1_PE y2_PE y1_PM y2_PM y1_PG y2_PG % product yields
  global m1 m2; % necessary for "findrm7"
  global J1_Sr J2_Sr h1_S h2_S h1_P h2_P h1_E h2_E h_V; % for testing dstate7

  err = testpars; % set and test parameter values on consistency
  if err ~= 0 % inconsistent parameter values
    return
  end  

  m1 = y1_es*k1*S1_r/(S1_r + k1/b1_S)/k1_E;
  m2 = y2_es*k2*S2_r/(S2_r + k2/b2_S)/k2_E;
  rm = fsolve('findrm7',[findr7(0) m1 m2]); % get max throughput, m1 m2
  hm = rm(1); m1 = rm(2); m2 = rm(3);

  nh = 100; H = linspace(1e-3, hm, nh); % set throughput rates
  X = zeros(nh,9);                 % initiate state matrix

  %% fill states at max throughput rate (last row of X)
  X(nh,:) = [S1_r S2_r 0 0 0 0 1e-8 m1 m2];
  
  %% fill states, starting from max throughput rate, working backwards
  for i = 1:(nh-1)
    h = H(nh-i);
    X(nh-i,:) = gstate7(X(nh+1-i,:))';
    %% J1_Sr = h*S1_r; J2_Sr = h*S2_r;
    %% h1_S = h2_S = h1_P = h2_P = h1_E = h2_E = h_V = h;
    %% d = dstate7(X(nh-i,:)); (d'*d) % must be very small
  end  
  
  clf;
  
  if exist('j', 'var')==1 % single plot mode
    switch j
	
      case 1
        xlabel('throughput rate'); ylabel('substrates'); 
        plot (H, X(:,1), 'b', H, X(:,2), 'r');

      case 4
        xlabel('throughput rate'); ylabel('products');
        plot (H, X(:,3), 'b', H, X(:,4), 'r');

      case 3
        xlabel('throughput rate'); ylabel('excreted reserves');
        plot (H, X(:,5), 'b', H, X(:,6), 'r');

      case 2
        %% xlabel('throughput rate'); ylabel('structure');
        plot (H, X(:,7), 'b');

      case 5
        xlabel('throughput rate'); ylabel('res densities');
        plot (H, X(:,8), 'b',H, X(:,9), 'r');

      case 6
        xlabel('throughput rate'); ylabel('ratio reserve 2/1');
        plot (H, X(:,9)./X(:,8), 'g');

      otherwise
	return;

    end
  else % multiple plot mode
    
        subplot (2, 3, 1);
        xlabel('throughput rate'); ylabel('substrates'); 
        plot (H, X(:,1), 'b', H, X(:,2), 'r');

        subplot (2, 3, 4);
        xlabel('throughput rate'); ylabel('products'); 
        plot (H, X(:,3), 'b', H, X(:,4), 'r');

        subplot (2, 3, 3);
        xlabel('throughput rate'); ylabel('excreted reserves');
        plot (H, X(:,5), 'b', H, X(:,6), 'r');

        subplot (2, 3, 2);
        xlabel('throughput rate'); ylabel('structure');
        plot (H, X(:,7), 'b');

        subplot (2, 3, 5);
        xlabel('throughput rate'); ylabel('res densities');
        plot (H, X(:,8), 'b', H, X(:,9), 'r');

        subplot (2, 3, 6);
	xlabel('throughput rate'); ylabel('ratio reserve 2/1');
        plot (H, X(:,9)./X(:,8), 'g');

  end
 