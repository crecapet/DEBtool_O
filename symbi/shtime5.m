function shtime5 (j)
  %% shtime5 (j)
  %% created: 2002/04/01 by Bas Kooijman, modified 2009/02/20
  %% time_plots for 'endosym'
  %% State vector:
  %% (1-3)substrates S1, S2, S2s, (4-7)products P1, P1s, P2, P2s
  %% (8,9)structure V, reserve density m of species 1
  %% (10,11)structure V, reserve density m of species 2 internal

  global h istate5; % initial values of state variables set in 'pars', 'pars5'

  %% no par testing because of y_es and y_ep redefinitions
  %% err = testpars; % test parameter values on consistency
  %% if err != 0 % inconsistent parameter values
  %%  return
  %% end
  pars_endosym; % set parameter values
  
  tmax = 5; nt = 200; t = linspace (0, tmax, nt); % set time points
  X_t  = lsode ('dstate5', istate5, t);

  clf;
  ttext = ['h = ', num2str(h)]; title(ttext);

  
  if exist('j', 'var')==1 % single plot mode
    switch j
	
      case 1
        xlabel('time'); ylabel('substrate 1'); 
        plot (t, X_t(:,1), 'b');

      case 2
        xlabel('time'); ylabel('substrate 2'); 
        plot (t, X_t(:,2), 'r.', t, X_t(:,3), 'r');	

      case 3
        xlabel('time'); ylabel('product 1');
        plot (t, X_t(:,4), 'b.', t, X_t(:,5), 'b');

      case 4
        xlabel('time'); ylabel('product 2');
        plot (t, X_t(:,6), 'r.', t, X_t(:,7), 'r');

      case 5
        xlabel('time'); ylabel('structure 1');
        plot (t, X_t(:,8), 'b');

      case 6
        xlabel('time'); ylabel('structure 2');
        plot (t, X_t(:,10), 'r');

      case 7
        xlabel('time'); ylabel('reserve density 1');
        plot (t, X_t(:,9), 'b');

      case 8
        xlabel('time'); ylabel('reserve density 2');
        plot (t, X_t(:,11), 'r');

      case 9
        xlabel('time'); ylabel('ratio structure 2/1');
        plot (t, X_t(:,10)./X_t(:,8), 'g');

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
        plot (t, X_t(:,2), 'r.', t, X_t(:,3), 'r');

        subplot (2, 4, 2);
        xlabel('time'); ylabel('product 1');
        plot (t, X_t(:,4), 'b.', t, X_t(:,5), 'b');

        subplot (2, 4, 6);
        xlabel('time'); ylabel('product 2');
        plot (t, X_t(:,6), 'r.', t, X_t(:,7), 'r');

        subplot (2, 4, 3);
        xlabel('time'); ylabel('structure 1');
        plot (t, X_t(:,8), 'b');

	subplot (2, 4, 7);
        xlabel('time'); ylabel('structure 2');
        plot (t, X_t(:,10), 'r');

	subplot (2, 4, 4);
        xlabel('time'); ylabel('reserve density 1');
        plot (t, X_t(:,9), 'b');

	subplot (2, 4, 8);
        xlabel('time'); ylabel('reserve density 2');
        plot (t, X_t(:,11), 'r');

  end

endfunction

  




