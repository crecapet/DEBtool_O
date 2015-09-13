function shbatch (j)
  %% shbatch (j)
  %% created: 2000/09/21 by Bas Kooijman, modified 2009/02/20
  
  global jT_EN_Am jT_EP_Am jT_EN_M jT_EP_M kT_E r y_EN_V y_EP_V
  global kap_EN kap_EP X_Nr X_N X_P X_Pr h h_X h_V m_EN m_EP
  
  h_X = 0; h_V = 0; h = 0; % 1/d, batch culture

  %% set initial conditions
  X_N  = X_Nr; X_P = X_Pr;
  m_EN = (jT_EN_Am - kap_EN*jT_EN_M)/((1 - kap_EN)*kT_E);
  m_EP = (jT_EP_Am - kap_EP*jT_EP_M)/((1 - kap_EP)*kT_E);
  a = (m_EN * kT_E  - jT_EN_M)/ y_EN_V;
  b = (m_EP * kT_E  - jT_EP_M)/ y_EP_V;
  r = 1/ (1/ a + 1/ b - 1/ (a + b));
  r  = fsolve('findrm',[r m_EN m_EP]);
 
  X0 = [X_N 0 X_P 0 r(2) r(3) 1e-4];
  
  tmax = 150; t = linspace (0, tmax, 100); % time-points
  r = 0; % initiate specific growth rate
  Xt = lsode ('dbatch', X0, t);      % integrate state variables

  clf; hold on;
 
  if exist('j', 'var') == 1 % single-plot mode
    multiplot(0,0); clf;
 
    switch j

      case 1         
      title('ammonia & excreted N-reserve');
      xlabel('time, d'); ylabel('ammonia, M');
      plot(t, Xt(:,1), 'b', t, Xt(:,2), '.b');

      case 2
      title('phospate & excreted P-reserve');
      xlabel('time, d'); ylabel('phosphate, M');
      plot(t, Xt(:,3),'r', t, Xt(:,4), '.r');

      case 3
      title('structure density');
      xlabel('time, d'); ylabel('structure, M');
      plot(t, Xt(:,7), 'g');

      case 4
      title('N-, P-reserve density');
      xlabel('time, d'); ylabel('res dens, mol/mol');
      plot(t, Xt(:,5), 'b', t, Xt(:,6), 'r');

      otherwise
      title('structure density');
      xlabel('time, d'); ylabel('structure, M');
      plot(t, Xt(:,7), 'g');
    
    end

  else % multi-plot mode
    %% top_title ('Batch culture'); does not seem to work

    subplot(2, 2, 1); clf;
    title ('ammonia & excreted N-reserve');
    xlabel('time, d'); ylabel('ammonia, M');
    plot(t, Xt(:,1), 'b', t, Xt(:,2), '.b');

    subplot(2, 2, 2); clf;
    title('phospate & excreted P-reserve');
    xlabel('time, d'); ylabel('phosphate, M');
    plot(t, Xt(:,3),'r', t, Xt(:,4), '.r');

    subplot(2, 2, 3); clf;
    title('structure density');
    xlabel('time, d'); ylabel('structure, M');
    plot(t, Xt(:,7), 'g');

    subplot(2, 2, 4); clf;
    title('reserve density');
    xlabel('time, d'); ylabel('res dens, mol/mol');
    plot(t, Xt(:,5), 'b', t, Xt(:,6), 'r');

  end
  