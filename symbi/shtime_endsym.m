function shtime (j)
  %% created: 2001/06/23 by Bas Kooijman, modified 2009/02/20
  %% time_plots for 'endosym'
  %% State vector:
  %% (1,2)substrates S (3,4)products P
  %% (5,6)structure V, reserve density m of species 1
  %% (7,8)structure V, reserve density m of species 2

  global h1_V h2_V h1_S h2_S h1_P h2_P h JSr_1 JSr_2 Sr_1 Sr_2 ...
      k1_E k2_E k1_M k2_M ...
      k1 k2 k1_S k2_S ki1_S ki2_S k1_P k2_P ki1_P ki2_P ...
      b1_S b2_S b1_SP b2_SP b1_P b2_P b1_PS b2_PS ...
      y1_EV y2_EV y1_ES y2_ES y1_EP y2_EP y1_Et y2_Et ...
      y1_St y2_St y1_Pt y2_Pt ...
      y1_PS y2_PS y1_PP y2_PP y1_PM y2_PM y1_PG y2_PG ...
      istate
  
  tmax = 100; t = linspace (0, tmax, 100); % set time points
  pars1; % set parameter values
  X_t  = lsode ('dstate1', istate, t);

  clf
  
  if exist('j', 'var')==1 % single plot mode
    switch j
	
      case 1
        xlabel('time'); ylabel('substrate'); 
        plot (t, 10*X_t(:,1)./X_t(:,2), 'g', ...
	      t, X_t(:,1), 'b', t, X_t(:,2), 'r');

      case 2
        xlabel('time'); ylabel('product');
        plot (t, 10*X_t(:,3)./X_t(:,4), 'g', ...
	      t, X_t(:,3), 'b', t, X_t(:,4), 'r');

      case 3
        xlabel('time'); ylabel('structure');
        plot (t, X_t(:,5)./X_t(:,7), 'g', ...
	      t, X_t(:,5), 'b', t, X_t(:,7), 'r');

      case 4
        xlabel('time'); ylabel('reserve density');
        plot (t, X_t(:,6)./X_t(:,8), 'g', ...
	      t, X_t(:,6), 'b', t, X_t(:,8), 'r');

      otherwise
	return;

    end
  else % multiple plot mode
    
        subplot (2, 2, 1)
        xlabel('time'); ylabel('substrate');
	    plot (t, 10*X_t(:,1)./X_t(:,2), 'g', ...
	      t, X_t(:,1), 'b', t, X_t(:,2), 'r');

        subplot (2, 2, 2)
        xlabel('time'); ylabel('product');
        plot (t, X_t(:,3)./X_t(:,4), 'g', ...
	      t, X_t(:,3), 'b', t, X_t(:,4), 'r');

        subplot (2, 2, 3)
        xlabel('time'); ylabel('structure');
        plot (t, X_t(:,5)./X_t(:,7), 'g', ...
	      t, X_t(:,5), 'b', t, X_t(:,7), 'r');

        subplot (2, 2, 4)
        xlabel('time'); ylabel('reserve density');
        plot (t, X_t(:,6)./X_t(:,8), 'g', ...
	      t, X_t(:,6), 'b', t, X_t(:,8), 'r');

  end