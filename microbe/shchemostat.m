function shchemostat (j)
  %% shchemostat (j)
  %% created 2000/10/20 by Bas Kooijman
  %% shows equilibria for a chemostat at a range of throughput rates
  %%  and a fixed concentration of substrate in the feed

  global w_O m_Em X_r jT_X_Am j_E_M j_E_J K kT_M kT_E g hT_a;
  global zeta h_m mu_O mu_M eta_O y_E_X y_E_V kap n_M n_O;
  
  n_h = 100; h  = linspace(1e-4,h_m,n_h)';    % 1/d, throughput rates

  [Xh, ph] = chemostat (h, X_r);
  %% Xh = [X, X_V, X_E, X_P, X_DV, X_DE, X_W, X_DW]
  %% ph = [p_T, p_A, p_D, p_G]
 
  if exist('j')==1 % single-plot mode

    switch j
      case 1
	clf
        gset title 'living & dead structure & reserve';
        xlabel('throughput rate, 1/d'); ylabel('mass, M');
        plot(h, Xh(:,2), 'g', h, Xh(:,5), '.g', ...
	     h, Xh(:,3), 'r', h, Xh(:,6), '.r');

      case 2
	clf
        gset title 'total and dead biomass';
        xlabel('throughput rate, 1/d'); ylabel('weight, g/l');
        plot(h, Xh(:,7) + Xh(:,8),'8', h, Xh(:,8), '.8');

      case 3
	clf
        gset title 'fraction of dead structure, biomass';
        xlabel('throughput rate, 1/d'); ylabel('fraction');
        plot(h, Xh(:,5)./(Xh(:,2) + Xh(:,5)), 'g', ...
	     h, Xh(:,8)./(Xh(:,7) + Xh(:,8)), '8');

      case 4
	clf
        xlabel('throughput rate, 1/d'); ylabel('substrate, M');
        plot(h, Xh(:,1), 'g');

      case 5
	clf
        xlabel('throughput rate, 1/d'); ylabel('product, M');
        plot(h, Xh(:,4), '8');

      case 6
	clf
        xlabel('throughput rate, 1/d'); ylabel('heat production, kJ/d');
        plot(h, ph(:,1), 'r');

      otherwise
	return;
	
    end
    
  else % multi-plot mode
    %%   top_title ('Chemostat culture'); does not seem to work
 
    subplot(2, 3, 1); clf
    gset title 'living & dead structure & reserve';
    xlabel('throughput rate, 1/d'); ylabel('mass, M');
    plot(h, Xh(:,2), 'g', h, Xh(:,5), '.g', ...
	 h, Xh(:,3), 'r', h, Xh(:,6), '.r');

    subplot(2, 3, 2); clf
    gset title 'total and dead biomass';
    xlabel('throughput rate, 1/d'); ylabel('weight, g/l');
    plot(h, Xh(:,7) + Xh(:,8),'8', h, Xh(:,8), '.8');

    subplot(2, 3, 3); clf
    gset title 'fraction of dead structure, biomass';
    xlabel('throughput rate, 1/d'); ylabel('fraction');
    plot(h, Xh(:,5)./(Xh(:,2) + Xh(:,5)), 'g', ...
	 h, Xh(:,8)./(Xh(:,7) + Xh(:,8)), '8');

    subplot(2, 3, 4); clf
    xlabel('throughput rate, 1/d'); ylabel('substrate, M');
    plot(h, Xh(:,1), 'g');

    subplot(2, 3, 5); clf
    xlabel('throughput rate, 1/d'); ylabel('product, M');
    plot(h, Xh(:,4), '8');

    subplot(2, 3, 6); clf
    xlabel('throughput rate, 1/d'); ylabel('heat production, kJ/d');
    plot(h, ph(:,1), 'r');

  end
