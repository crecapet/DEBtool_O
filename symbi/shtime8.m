function shtime8 (j)
  %% shtime8 (j)
  %% created: 2002/04/01 by Bas Kooijman, modifoed 2009/02/20
  %% time_plots for 'endosym'
  %% Single species, 1 structure, 1 reserve, 2 substrates, 2 products
  %% State vector:
  %% (1-2)substrates S (3-4)products P
  %% (5-6)structure V, reserve density m of species

  global istate8; % initial values of state variables (set in 'pars', 'pars8')
  
  err = testpars; % test parameter values on consistency
  if err ~= 0 % inconsistent parameter values
    return
  end

  tmax = 200; nt = 200; t = linspace (0, tmax, nt); % set time points
  X_t  = lsode ('dstate8', istate8, t); % integrate dynamic system

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
        xlabel('time'); ylabel('structure');
        plot (t, X_t(:,5), 'b');

      case 4
        xlabel('time'); ylabel('reserve density');
        plot (t, X_t(:,6), 'b');

      otherwise
	return;

    end
  else % multiple plot mode
        subplot (2, 2, 1);
        xlabel('time'); ylabel('substrates');
	    plot (t, X_t(:,1), 'b', t, X_t(:,2), 'r');

        subplot (2, 2, 2);
        xlabel('time'); ylabel('products');
        plot (t, X_t(:,3), 'b', t, X_t(:,4), 'r');

        subplot (2, 2, 3);
        xlabel('time'); ylabel('structure');
        plot (t, X_t(:,5), 'b');

        subplot (2, 2, 4);
        xlabel('time'); ylabel('reserve density');
        plot (t, X_t(:,6), 'b');
  end
  




