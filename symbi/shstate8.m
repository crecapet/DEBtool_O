function shstate8 (j)
  %% shstate8 (j)
  %% created: 2002/04/01 by Bas Kooijman, modified 2009/02/20
  %% chemostat equilibrium plots for 'endosym'
  %% State vector:
  %% (1-2)substrates S (3-4)products P
  %% (5-6)structure V, reserve density

  global h S1_r S2_r ... % reactor setting
      k_E k_M ... % res turnover, maintenance
      k ... % max assimilation
      b1_S b2_S ... % uptake rates
      y_EV % costs for structure, reserves
  global m1 m2; % necessary for 'findrm7'
  global J1_Sr J2_Sr h1_S h2_S h1_P h2_P h_V; % for testing dstate7

  %%   gset term postscript color solid  'Times-Roman' 40
  %%   gset output 'state8.ps'
  %%   gset xrange [0:.5]
  %%   gset xtics 0, .2, .5
  %%   gset yrange [0:100]
  %%   gset ytics 0, 20, 100

  err = testpars; % set and test parameter values on consistency
  if err ~= 0 % inconsistent parameter values
    return
  end
  pars_endosym; % set parameter values
  

  %% at max throughput, where V = 0; Si = Si_r
  j_E = 1/(1/k + 1/(S1_r*b1_S) + 1/(S2_r*b2_S) - 1/(S1_r*b1_S + S2_r*b2_S));
  m = j_E/k_E; % max res density
  r = (k_E*m - k_M*y_EV)/(m + y_EV); % max spec growth rate
  hm = r;

  nh = 100; H = linspace(1e-3, hm, nh); % set throughput rates
  X = zeros(nh,6);                 % initiate state matrix

  %% fill states at max throughput rate (last row of X)
  X(nh,:) = [S1_r S2_r 0 0 1e-8 m];
  
  %% fill states, starting from max throughput rate, working backwards
  for i = 1:(nh-1)
    h = H(nh-i);
    X(nh-i,:) = gstate8(X(nh+1-i,:))';
    %% J1_Sr = h*S1_r; J2_Sr = h*S2_r;
    %% h1_S = h2_S = h1_P = h2_P = h_V = h;
    %% d = dstate8(X(nh-i,:)); (d'*d) % must be very small
  end  
  
  clf;
  
  if exist('j', 'var')==1 % single plot mode
    switch j
	
      case 1
        xlabel('throughput rate'); ylabel('substrates'); 
        plot (H, X(:,1), 'b', H, X(:,2), 'r');

      case 3
        xlabel('throughput rate'); ylabel('products');
        plot (H, X(:,3), 'b', H, X(:,4), 'r');

      case 2
        %% xlabel('throughput rate'); ylabel('structure');
        plot (H, X(:,5), 'b');

      case 4
        xlabel('throughput rate'); ylabel('res density');
        plot (H, X(:,6), 'b');


      otherwise
	return;

    end
  else % multiple plot mode
    
        subplot (2, 2, 1);
        xlabel('throughput rate'); ylabel('substrates'); 
        plot (H, X(:,1), 'b', H, X(:,2), 'r');

        subplot (2, 2, 3);
        xlabel('throughput rate'); ylabel('products'); 
        plot (H, X(:,3), 'b', H, X(:,4), 'r');

        subplot (2, 2, 2);
        xlabel('throughput rate'); ylabel('structure');
        plot (H, X(:,5), 'b');

        subplot (2, 2, 4);
        xlabel('throughput rate'); ylabel('res density');
        plot (H, X(:,6), 'b');

  end
 