function shtime4 (j)
  %% shtime4 (j)
  %% created: 2002/04/01 by Bas Kooijman, modified 2009/02/20
  %% time_plots for 'endosym'
  %% State vector:
  %% (1-4)substrates S (5-10)products P
  %% (11,12)structure V, reserve density m of species 1
  %% (13,14)structure V, reserve density m of species 2 internal

  global h istate4; % initial values of state variables set in 'pars', 'pars4'

  err = testpars; % test parameter values on consistency
  if err ~= 0 % inconsistent parameter values
    return
  end
  pars_endosym; % set parameter values
  
  tmax = 100; nt = 200; t = linspace (0, tmax, nt); % set time points
  X_t  = lsode ('dstate4', istate4, t);

  clf;
  ttext = ['h = ', num2str(h)]; title(ttext);

  if exist('j', 'var')==1 % single plot mode
    switch j
	
      case 1
        xlabel('time'); ylabel('substrate 1'); 
        plot (t, X_t(:,1), 'b');

      case 2
        xlabel('time'); ylabel('substrate 2'); 
        plot (t, X_t(:,2), 'r.', t, X_t(:,3), 'r.', t, X_t(:,4), 'r');


      case 3
        xlabel('time'); ylabel('product 1');
        plot (t, X_t(:,5), 'b.', t, X_t(:,6), 'b.', t, X_t(:,7), 'b');

      case 4
        xlabel('time'); ylabel('product 2');
        plot (t, X_t(:,8), 'r.', t, X_t(:,9), 'r.', t, X_t(:,10), 'r');

      case 5
        xlabel('time'); ylabel('structure 1');
        plot (t, X_t(:,11), 'b');

      case 6
        xlabel('time'); ylabel('structure 2');
        plot (t, X_t(:,13), 'r');

      case 7
        xlabel('time'); ylabel('reserve density 1');
        plot (t, X_t(:,12), 'b');

      case 8
        xlabel('time'); ylabel('reserve density 2');
        plot (t, X_t(:,14), 'r');

      case 9
        xlabel('time'); ylabel('ratio structure 2/1');
        plot (t, X_t(:,13)./X_t(:,11), 'g');

      otherwise
	return;

    end
  else % multiple plot mode
        ttext = ['h = ', num2str(h)]; title(ttext);

        subplot (2, 4, 1);
        xlabel('time'); ylabel('substrate 1'); 
        plot (t, X_t(:,1), 'b');

        subplot (2, 4, 5); 
        xlabel('time'); ylabel('substrate 2'); 
        plot (t, X_t(:,2), 'r.', t, X_t(:,3), 'r.', t, X_t(:,4), 'r');

        subplot (2, 4, 2);
        xlabel('time'); ylabel('product 1');
        plot (t, X_t(:,5), 'b.', t, X_t(:,6), 'b.', t, X_t(:,7), 'b');

        subplot (2, 4, 6);
        xlabel('time'); ylabel('product 2');
        plot (t, X_t(:,8), 'r.', t, X_t(:,9), 'r.', t, X_t(:,10), 'r');

        subplot (2, 4, 3);
        xlabel('time'); ylabel('structure 1');
        plot (t, X_t(:,11), 'b');

	subplot (2, 4,7);
        xlabel('time'); ylabel('structure 2');
        plot (t, X_t(:,13), 'r');

	subplot (2, 4, 4);
        xlabel('time'); ylabel('reserve density 1');
        plot (t, X_t(:,12), 'b');

	subplot (2, 4, 8);
        xlabel('time'); ylabel('reserve density 2');
        plot (t, X_t(:,14), 'r');

  end