function shtime0_mixo (j)
  %% shtime0_mixo (j)
  %% created: 2001/08/25 by Bas Kooijman, modified 2009/02/20
  %% time_plots for 'mixo': 0-reserves
  %% 
  %% State vector:
  %% (1) C DIC (2) N DIN (3) D Detritus (4) V structure

  global istate; % initial states set in 'pars0_mixo'
  %% global Xinf;
  
  tmax = 100; nt = 100; t = linspace (0, tmax, nt); % set time points
  pars0_mixo; % set parameter values
  X_t  = lsode ('dstate0_mixo', istate, t);
  %% Xinf = X_t(tmax,:);


  %% %% check for conservation of carbon and nitrogen
  %% global n_NV; % for check on mass conservation
  %% C = X_t(:,1) + X_t(:,3) + X_t(:,4);
  %% N = X_t(:,2) + n_NV * (X_t(:,3) + X_t(:,4));
  
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
        xlabel('time, d'); ylabel('detritus, muM');
        plot (t, X_t(:,3), '6');

      case 4
        xlabel('time, d'); ylabel('structure, muM');
        plot (t, X_t(:,4), 'g');

      otherwise
	return;

    end
  else % multiple plot mode
    
        subplot (2, 2, 1)
        xlabel('time, d'); ylabel('DIC, muM');
	    plot (t, X_t(:,1), '8');

        subplot (2, 2, 2)
        xlabel('time, d'); ylabel('DIN, muM');
        plot (t, X_t(:,2), 'b');

        subplot (2, 2, 3)
        xlabel('time, d'); ylabel('detritus, muM');
        plot (t, X_t(:,3), '6');

        subplot (2, 2, 4)
        xlabel('time, d'); ylabel('structure, muM');
        plot (t, X_t(:,4), 'g');

  end
