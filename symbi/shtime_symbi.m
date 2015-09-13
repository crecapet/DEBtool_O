function shtime_symbi (j)
  %% shtime (j)
  %% created: 2000/10/01 by Bas Kooijman, modified 2009/02/20
  %% time_plots for 'symbi'
  %% State vector:
  %%   X_t = [X; X_N; X_CH; X_VA; m_EC; m_EN; X_VH; m_E]
  %%   X: substrate        X_N: nitrogen      X_CH: carbo-hydrate
  %%   X_VA: struc autotr  m_EC: C-res dens   m_EN: N-res density
  %%   X_VH: struc hetero  m_E: res density

  global X_R X_RN n_N_X n_N_E n_N_VH n_N_VA
  
  tmax = 500; t = linspace (0, tmax, 100); % set time points
  X_t = [X_R; X_RN; 0.00001; 0.00001; 1; 1; 0.00001; 1]; % initial state
  X_t  = lsode ('dx', X_t, t);

  clf
  
  if exist('j', 'var')==1 % single plot mode
    switch j
	
      case 1
        xlabel('time'); ylabel('reserves'); 
        plot (t, 100*X_t(:,5), 'b', t, X_t(:,6), '6', t, X_t(:,8), 'r');

      case 2
        xlabel('time'); ylabel('substrates');
        plot (t, X_t(:,1), 'r', t, X_t(:,2), 'b', t, X_t(:,3), '6');

      case 3
        xlabel('time'); ylabel('structures');
        plot (t, X_t(:,4), 'g', t, X_t(:,7), 'r');

      case 4
        xlabel('time'); ylabel('total N, C');
        Ntot = X_t(:,2) + n_N_X*X_t(:,1) + (n_N_VA + ...
         X_t(:,5)).*X_t(:,4) + (n_N_VH + n_N_E*X_t(:,8)).*X_t(:,7);

	Ctot = X_t(:,1) + X_t(:,3) + (1 + X_t(:,6)).*X_t(:,4) + ...
         (1+ X_t(:,8)).*X_t(:,7);
        plot (t, Ntot, 'b', t, Ctot, '6');

      otherwise
	return;

    end
  else % multiple plot mode
    
    subplot (2, 2, 1)
    xlabel('time'); ylabel('reserves'); 
    plot (t, 100*X_t(:,5), 'b', t, X_t(:,6), '6', t, X_t(:,8), 'r');

    subplot (2, 2, 2)
    xlabel('time'); ylabel('substrates');
    plot (t, X_t(:,1), 'r', t, X_t(:,2), 'b', t, X_t(:,3), '6');

    subplot (2, 2, 3)
    xlabel('time'); ylabel('structures');
    plot (t, X_t(:,4), 'g', t, X_t(:,7), 'r');

    subplot (2, 2, 4)
    xlabel('time'); ylabel('total N, C');
    Ntot = X_t(:,2) + n_N_X*X_t(:,1) + (n_N_VA + ...
         X_t(:,5)).*X_t(:,4) + (n_N_VH + n_N_E*X_t(:,8)).*X_t(:,7);
    Ctot = X_t(:,1) + X_t(:,3) + (1 + X_t(:,6)).*X_t(:,4) + ...
         (1+ X_t(:,8)).*X_t(:,7);
    plot (t, Ntot, 'b', t, Ctot, '6');

  end

endfunction

  