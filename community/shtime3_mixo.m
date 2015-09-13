function shtime3_mixo (j)
  %% shtime3 (j)
  %% created: 2001/08/29 by Bas Kooijman, modified 2009/02/20
  %% time_plots for 'mixo': 3-reserves
  
  %% State vector:
  %%   (1) C DIC (2) N DIN (3) DV V-Detritus (4) DE E-Detritus
  %%   (5) V structure (6) E reserve (7) EC C-reserve (8) EN N-reserve

  global istate; % initial states set in 'pars3_mixo'
  
  tmax = 500; nt = 100; t = linspace (0, tmax, nt); % set time points
  pars3_mixo; % set parameter values
  X_t  = lsode ('dstate3_mixo', istate, t);

  %% %% check for conservation of carbon and nitrogen
  %% global n_NV n_NE n_NEN n_CEC; % for check on mass conservation
  %% C = X_t(:,1) + X_t(:,3) + X_t(:,4) + X_t(:,5) + X_t(:,6) + X_t(:,7);
  %% N = X_t(:,2) + n_NV * (X_t(:,3) + X_t(:,5)) + ...
  %% n_NE * (X_t(:,4) + X_t(:,6)) + n_NEN * X_t(:,8);
  
  %% subplot(1,2,1)
  %% xlabel('time, d'); ylabel('total carbon');
  %% plot (t, C, '8');

  %% subplot(1,2,2)
  %% xlabel('time, d'); ylabel('total nitrogen');
  %% plot (t, N, 'b');
  %% return
  clf
  
  if exist('j', 'var')==1 % single plot mode
    switch j
	
      case 1
        xlabel('time, d'); ylabel('DIC, muM'); 
        plot (t, X_t(:,1), '8');

      case 2
        xlabel('time, d'); ylabel('DIN, muM');
        plot (t, X_t(:,2), 'b');

      case 3
        xlabel('time, d'); ylabel('struc-detritus, muM');
        plot (t, X_t(:,3), '6');

      case 4
        xlabel('time, d'); ylabel('res-detritus, muM');
        plot (t, X_t(:,4), '6');

      case 5
        xlabel('time, d'); ylabel('structure, muM');
        plot (t, X_t(:,5), 'g');

      case 6
        xlabel('time, d'); ylabel('reserves, muM');
        plot (t, X_t(:,6), 'r', t, X_t(:,7), '8', ...
	      t, X_t(:,8), 'b');

      otherwise
	return;

    end
  else % multiple plot mode
    
        subplot (2, 3, 1)
        xlabel('time, d'); ylabel('DIC, muM');
	    plot (t, X_t(:,1), '8');

        subplot (2, 3, 2)
        xlabel('time, d'); ylabel('DIN, muM');
        plot (t, X_t(:,2), 'b');

        subplot (2, 3, 3)
        xlabel('time, d'); ylabel('V-detritus, muM');
        plot (t, X_t(:,3), '8');

        subplot (2, 3, 4)
        xlabel('time, d'); ylabel('E-detritus, muM');
        plot (t, X_t(:,4), '6');

        subplot (2, 3, 5)
        xlabel('time, d'); ylabel('structure, muM');
        plot (t, X_t(:,5), 'g');

	subplot (2, 3, 6)
        xlabel('time, d'); ylabel('reserves, muM');
        plot (t, X_t(:,6), 'r', t, X_t(:,7), '8', ...
	      t, X_t(:,8), 'b');

  end



