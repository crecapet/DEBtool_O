function shchem1 (j)
  %% shchem1 (j)
  %% created: 2000/09/21 by Bas Kooijman, modofied 2009/02/20
  
  global jT_EN_Am jT_EP_Am jT_EN_M jT_EP_M kT_E y_N_EN y_P_EP n_O
  global kap_EN kap_EP X_Nr X_N X_P X_Pr m_EN m_EP h y_EN_V y_EP_V


  %% set initial conditions
  X_N  = X_Nr; X_P = X_Pr;
  m_EN = (jT_EN_Am - kap_EN*jT_EN_M)/((1 - kap_EN)*kT_E);
  m_EP = (jT_EP_Am - kap_EP*jT_EP_M)/((1 - kap_EP)*kT_E);
  a = (m_EN * kT_E  - jT_EN_M)/ y_EN_V;
  b = (m_EP * kT_E  - jT_EP_M)/ y_EP_V;
  r = 1/ (1/ a + 1/ b - 1/ (a + b));
  r = fsolve('findrm',[r m_EN m_EP]);
  h_m = r(1); h = h_m; % 1/d, max throughput rate

  nh = 100; H = linspace(1e-6, h_m, nh);      % 1/d, throuphput rates
  X = zeros(nh,7);                            %  initialize plot data
  X0 = [X_N 0 X_P 0 r(2) r(3) 1e-8];          % first guess at h_m
  X(nh,:) = fsolve('dchem1',X0)';             % we start at h = h_m

  for i= 1:(nh-1)                             % and work back to h = 0
    h = H(nh-i);                              % 1/d, throughput rate
    X(nh-i,:) = fsolve('dchem1',X(nh-i+1,:))';% fill plot data
  end
  
  clf; hold on;
 
  if exist('j', 'var') == 1 % single-plot mode
 
    switch j

      case 1         
        title('ammonia & excreted N-reserve');
        xlabel('throughput rate, 1/d'); ylabel('ammonia, M');
        plot(H, X(:,1), 'b', H, X(:,2), '.b');

      case 2
        title('phospate & excreted P-reserve');
        xlabel('throughput rate, 1/d'); ylabel('phosphate, M');
        plot(H, X(:,3),'r', H, X(:,4), '.r');

      case 3
	title('total ammonia & phospate in medium');
	xlabel('throughput rate, 1/d'); ylabel('amm & phos, M');
	plot(H, X(:,1) + y_N_EN*X(:,2), 'b', ...
	     H, X(:,3) + y_P_EP*X(:,4), 'r');

      case 4
        title('structure');
        xlabel('throughput rate, 1/d'); ylabel('structure, M');
        plot(H, X(:,7), 'g');

      case 5
        title('N-, P-reserve density');
        xlabel('throughput rate, 1/d'); ylabel('res dens, mol/mol');
        plot(H, X(:,5), 'b', H, X(:,6), 'r');

      case 6
	title('N/C & P/C in biomass');
	xlabel('throughput rate, 1/d'); ylabel('N/C & P/C, mol/mol');
	plot(H, n_O(4,1) + n_O(4,2)*X(:,5), 'b', ...
	     H, n_O(4,1) + n_O(4,2)*X(:,6), 'r');

      otherwise
        title('structure');
        xlabel('throughput rate, 1/d'); ylabel('structure, M');
        plot(H, X(:,7), 'g');
    
    end

  else % multi-plot mode
    %% top_title ('Chemostat culture'); does not seem to work

    subplot(2, 3, 1); clf;
    title('ammonia & excreted N-reserve');
    xlabel('throughput rate, 1/d'); ylabel('ammonia, M');
    plot(H, X(:,1), 'b', H, X(:,2), '.b');

    subplot(2, 3, 2); clf;
    title('phospate & excreted P-reserve');
    xlabel('throughput rate, 1/d'); ylabel('phosphate, M');
    plot(H, X(:,3),'r', H, X(:,4), '.r');

    subplot(2, 3, 3); clf;
    title('total ammonia & phospate in medium');
    xlabel('throughput rate, 1/d'); ylabel('amm & phos, M');
    plot(H, X(:,1) + y_N_EN*X(:,2), 'b', ...
	 H, X(:,3) + y_P_EP*X(:,4), 'r');

    subplot(2, 3, 4); clf;
    title('structure');
    xlabel('throughput rate, 1/d'); ylabel('structure, M');
    plot(H, X(:,7), 'g');

    subplot(2, 3, 5); clf;
    title('reserve density');
    xlabel('throughput rate, 1/d'); ylabel('res dens, mol/mol');
    plot(H, X(:,5), 'b', H, X(:,6), 'r');

    subplot(2, 3, 6); clf;
    title('N/C & P/C in biomass');
    xlabel('throughput rate, 1/d'); ylabel('N/C & P/C, mol/mol');
    plot(H, n_O(4,1) + n_O(4,2)*X(:,5), 'b', ...
	 H, n_O(4,1) + n_O(4,2)*X(:,6), 'r');
  end
