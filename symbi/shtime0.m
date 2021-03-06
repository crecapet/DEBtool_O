function shtime0 (j)
  %% shtime0 (j)
  %% created: 2002/04/01 by Bas Kooijman, modified 2009/02/20
  %% time_plots for 'endosym'
  %% 
  %% State vector:
  %% (1,2)substrates S (3,4)products P
  %% (5,6)structure V, reserve density m of species 1
  %% (7,8)structure V, reserve density m of species 2

  global istate0; % initial states set in %pars', 'pars0'
  
  err = testpars; % test parameter values on consistency
  if err ~= 0 % inconsistent parameter values
    return
  end
  pars_endosym; % set parameter values

  tmax = 100; nt = 200; t = linspace (0, tmax, nt); % set time points
  X_t  = lsode ('dstate0', istate0, t);

  clf;
  
  if exist('j', 'var') == 1  % single plot mode
    switch j
	
      case 1
        xlabel('time'); ylabel('substrate'); 
        plot (t, X_t(:,1), 'b', t, X_t(:,2), 'r');

      case 2
        xlabel('time'); ylabel('product');
        plot (t, X_t(:,3), 'b', t, X_t(:,4), 'r');

      case 3
        xlabel('time'); ylabel('structure');
        plot (t, X_t(:,5), 'b', t, X_t(:,7), 'r');

      case 4
        xlabel('time'); ylabel('reserve density');
        plot (t, X_t(:,6), 'b', t, X_t(:,8), 'r');

      case 5
        xlabel('time'); ylabel('ratio of structure 2/1');
        plot (t, X_t(:,7)./X_t(:,5), 'g');

      otherwise
	return;

    end
  else % multiple plot mode
    
        subplot (2, 2, 1);
        xlabel('time'); ylabel('substrate');
	plot (t, X_t(:,1), 'b', t, X_t(:,2), 'r');

        subplot (2, 2, 2);
        xlabel('time'); ylabel('product');
        plot (t, X_t(:,3), 'b', t, X_t(:,4), 'r');

        subplot (2, 2, 3);
        xlabel('time'); ylabel('structure');
        plot (t, X_t(:,5), 'b', t, X_t(:,7), 'r');

        subplot (2, 2, 4);
        xlabel('time'); ylabel('reserve density');
        plot (t, X_t(:,6), 'b', t, X_t(:,8), 'r');

  end

endfunction

  




