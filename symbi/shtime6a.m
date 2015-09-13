function shtime6a (j)
  %% shtime6a (j)
  %% created: 2001/07/30 by Bas Kooijman, modified 2009/02/20
  %% time_plots for 'endosym'
  %% State vector:
  %% (1,2)structure V, reserve density m of species 1
  %% (3,4)structure V, reserve density m of species 2 internal

  global h1_V h2_V ...  % hazard rates
      k1_E k2_E k1_M k2_M ... % res turnover, maintenance
      k1 k2 ... % max assimilation
      rho1_P rho2_P ... % binding probabilities
      y1_EV y2_EV ... % costs for structure
      y1_PE y2_PE y1_PM y2_PM y1_PG y2_PG % product yields
  global m1 m2 V1 V2 r1 r2;

  tmax = 100; nt = 100; t = linspace (0, tmax, nt); % set time points
  pars6a; % set parameter values
  V1 = 1; V2 = 0.1;
  j_E = fsolve('findj_epi6a', [k1 k2]);
  m1 = j_E(1)/k1_E; m2 = j_E(2)/k2_E;
  %% m1=m2=.1;
  istate = [V1, m1, V2, m2];
  
  X_t  = lsode ('dstate6a', istate, t);
  R1 = (k1_E*X_t(:,2) - k1_M*y1_EV) ./ (X_t(:,2) + y1_EV); % spec growth rate
  R2 = (k2_E*X_t(:,4) - k2_M*y2_EV) ./ (X_t(:,4) + y2_EV); % spec growth rate

  V1 = 1; V2 = 1;
  j_E = fsolve('findj_epi6a',[k1 k2]);
  m1 = j_E(1)/k1_E; m2 = j_E(2)/k2_E;
  %% m1=m2=.1;
  istate = [V1, m1, V2, m2];
  
  X1_t  = lsode ('dstate6a', istate, t);
  R11 = (k1_E*X1_t(:,2) - k1_M*y1_EV)./(X1_t(:,2) + y1_EV); % spec growth rate
  R21 = (k2_E*X1_t(:,4) - k2_M*y2_EV)./(X1_t(:,4) + y2_EV); % spec growth rate

  V1 = 1; V2 = 10;
  j_E = fsolve('findj_epi6a',[k1 k2]);
  m1 = j_E(1)/k1_E; m2 = j_E(2)/k2_E;
  %% m1=m2=.1;
  istate = [V1, m1, V2, m2];
  
  X2_t  = lsode ('dstate6a', istate, t);
  R12 = (k1_E*X2_t(:,2) - k1_M*y1_EV)./(X2_t(:,2) + y1_EV); % spec growth rate
  R22 = (k2_E*X2_t(:,4) - k2_M*y2_EV)./(X2_t(:,4) + y2_EV); % spec growth rate
  rmin=min([R1 R2 R11 R21 R12 R22]); rmax=max([R1 R2 R11 R21 R12 R22]);
  
  clf;
  
  if exist('j', 'var')==1 % single plot mode
    switch j
	
      case 1
        xlabel('time'); ylabel('ln structures'); 
        plot (t, log(X_t(:,1)), 'g', t, log(X_t(:,3)), 'g', ...
	      t, log(X1_t(:,1)), 'r', t, log(X1_t(:,3)), 'r', ...
	      t, log(X2_t(:,1)), 'b', t, log(X2_t(:,3)), 'b');

      case 2
        xlabel('time'); ylabel('reserves'); 
        plot (t, X_t(:,2), 'g', t, X_t(:,4), 'g', ...
	      t, X1_t(:,2), 'r', t, X1_t(:,4), 'r', ...
	      t, X2_t(:,2), 'b', t, X2_t(:,4), 'b');
	
      case 3
        xlabel('time'); ylabel('ratio');
        plot (t, X_t(:,3)./X_t(:,1), 'g', ...
	      t, X1_t(:,3)./X1_t(:,1), 'r', ...
	      t, X2_t(:,3)./X2_t(:,1), 'b');

      case 4
        xlabel('spec growth rate 1'); ylabel('spec growth rate 2');
        plot (R1, R2, 'g', R11, R21, 'r', R12, R22, 'b', ...
	      [rmin rmax], [rmin rmax], 'r');
	
      otherwise
	return;

    end
  else % multiple plot mode
    
    
        subplot (2, 2, 1); clf;
        xlabel('time'); ylabel('ln structures'); 
        plot (t, log(X_t(:,1)), 'g', t, log(X_t(:,3)), 'r');

        subplot (2, 2, 2); clf;
        xlabel('time'); ylabel('reserves'); 
        plot (t, X_t(:,2), 'g', t, X_t(:,4), 'r');

        subplot (2, 2, 3); clf;
        xlabel('time'); ylabel('ratio');
        plot (t, X_t(:,3)./X_t(:,1), 'g');

        subplot (2, 2, 4); clf;
        xlabel('spec growth rate 1'); ylabel('spec growth rate 2');
        plot (r1, r2, 'g', [0 0.4], [0 0.4], 'r');

  end