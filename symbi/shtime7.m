function shtime7 (j)
  %% shtime7 (j)
  %% created: 2002/04/01 by Bas Kooijman
  %% time_plots for 'endosym': One structure, 2 reserves
  %% State vector:
  %% (1-2)substrates S (3-4)products P (5-6) excreted reserves
  %% (7-9)structure V, reserve densities 1,2

  global istate7; % initial values of state variables (set in 'pars', 'pars7')

  err = testpars; % test parameter values on consistency
  if err ~= 0 % inconsistent parameter values
    return
  end

  tmax = 200; nt=200; t = linspace (0, tmax, nt); % set time points
  X_t  = lsode ('dstate7', istate7, t);

  clf;
  
  if exist('j', 'var')==1 % single plot mode
    switch j
	
      case 1
        xlabel('time'); ylabel('substrates'); 
        plot (t, X_t(:,1), 'b', t, X_t(:,2), 'r');

      case 2
        xlabel('time'); ylabel('products');
        plot (t, X_t(:,3), 'b', t, X_t(:,4), 'r');
   
      case 3
        xlabel('time'); ylabel('excreted reserves');
        plot (t, X_t(:,5), 'b', t, X_t(:,6), 'r');

      case 4
        xlabel('time'); ylabel('structure');
        plot (t, X_t(:,7), 'b');

      case 5
        xlabel('time'); ylabel('res densities');
        plot (t, X_t(:,8), 'b',t, X_t(:,9), 'r');

      case 6
        xlabel('time'); ylabel('ratio reserve 2/1');
        plot (t, X_t(:,9)./X_t(:,8), 'g');

      otherwise
	return;

    end
  else % multiple plot mode
    
        subplot (2, 3, 1);
        xlabel('time'); ylabel('substrates'); 
        plot (t, X_t(:,1), 'b', t, X_t(:,2), 'r');

        subplot (2, 3, 2);
        xlabel('time'); ylabel('products'); 
        plot (t, X_t(:,3), 'b', t, X_t(:,4), 'r');

        subplot (2, 3, 3);
        xlabel('time'); ylabel('excreted reserves');
        plot (t, X_t(:,5), 'b', t, X_t(:,6), 'r');

        subplot (2, 3, 4);
        xlabel('time'); ylabel('structure');
        plot (t, X_t(:,7), 'b');

        subplot (2, 3, 5);
        xlabel('time'); ylabel('res densities');
        plot (t, X_t(:,8), 'b', t, X_t(:,9), 'r');

        subplot (2, 3, 6);
        xlabel('time'); ylabel('ratio reserve 2/1');
        plot (t, X_t(:,9)./X_t(:,8), 'g');

  end