function shbatch (j)
  %% shbatch (j)
  %% created at 2000/10/20 by Bas Kooijman
  %% calculates state variables in a fed batch culture
  %% X   = Xt(1);  X_V = Xt(2);  e_  = Xt(3);
  %% X_DV = Xt(4); X_DE = Xt(5); X_P = Xt(6);

  global w_O m_Em h h_X h_V h_P X_r;
  
  h_P = 0; h_V = 0; h_X = 0; % set removal rates to zero
  h = 0.1;                 % set substrate supply rate
  X0 = [X_r 1e-3 1 0 0 0]; % set initial conditions
  t_max = 500; t  = linspace(0,t_max,100); % set time points
  Xt = lsode('dchem', X0, t);
  X_E = Xt(:,3).*Xt(:,2)*m_Em;
  X_W =  w_O(2)*Xt(:,2) + w_O(3)*X_E;
  X_DW = w_O(2)*Xt(:,4) + w_O(3)*Xt(:,5);
  
  if exist('j', 'var') == 1 % single-plot mode
    switch j
    case 1
      clf
      title('living & dead structure & reserve');
      xlabel('time, d'); ylabel('mass, M');
      plot(t, Xt(:,2), 'g', t, Xt(:,4), '.g', ...
        t, X_E, 'r', t, Xt(:,5), '.r');

    case 2
      clf
      title ('total and dead biomass');
      xlabel('time, d'); ylabel('weight, g/l');
      plot(t, X_W + X_DW,'8', t, X_DW, '.8');

    case 3
      clf
      xlabel('time, d'); ylabel('substrate, M');
      plot(t, Xt(:,1), 'g');

    case 4
      clf
      xlabel('time, d'); ylabel('product, M');
      plot(t, Xt(:,6), 'r');

    otherwise
      return;
      
    end
  
  else % multi=plot mode
  
    %%   top_title ('Batch culture'); does not seem to work
 
    subplot(2, 2, 1); clf
    gset title 'living & dead structure & reserve';
    xlabel('time, d'); ylabel('mass, M');
    plot(t, Xt(:,2), 'g', t, Xt(:,4), '.g', ...
       t, X_E, 'r', t, Xt(:,5), '.r');

    subplot(2, 2, 2); clf
    gset title 'total and dead biomass';
    xlabel('time, d'); ylabel('weight, g/l');
    plot(t, X_W + X_DW,'8', t, X_DW, '.8');

    subplot(2, 2, 3); clf
    xlabel('time, d'); ylabel('substrate, M');
    plot(t, Xt(:,1), 'g');

    subplot(2, 2, 4); clf
    xlabel('time, d'); ylabel('product, M');
    plot(t, Xt(:,6), 'r');
  end 
