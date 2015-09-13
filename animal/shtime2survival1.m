function shtime2survival1
  %% shtime2survival1
  %% created 2000/09/05 by Bas Kooijman
  %% plot survival as a function of time
  %% similar to shtime2survival, but damage induction now proportional
  %% to total oxygen flux, including assimilation

  global f l_b l_p l_h g kT_M hT_a eta_O n_M n_O L_m d_O w_O;

  clf; hold on;
  title('survival probability for f = 1, 0.8, 0.6, ..');
  xlabel('time, d'); ylabel('survival probability');
  O2M = (- n_M\n_O).'; % -, matrix that converts organic to mineral fluxes
  
  f = 1;                          % -, scaled functional response
  l_i = f - l_h;
  while l_i > l_b
    r_B = kT_M/(3*(1 + f/g));     % 1/d, von Bert growth rate
      
    t_b = incub(f,g,l_b,kT_M);    % d, time to reach L_b (birth)	
    t_99 = t_b + log((l_i - l_b)/(l_i - 0.99*l_i))/r_B; 
		      % d, time to reach length 0.99*L_i ("fully" grown)
    if f > l_p      
      t_p = t_b + log((l_i - l_b)/(l_i - l_p))/r_B; 
		      % d, time to reach length L_p (puberty)
    else
      t_p = t_99;
    end
    
    %% d, time points for embryo, juvenile and adult
    n_e = 40; t_e = linspace(0, t_b, n_e);
    if t_p < t_99
      n_j = 50; t_j = linspace(t_b, t_p, n_j);
      n_a = 50; t_a = linspace(t_p, t_99, n_a);
      t = [t_e t_j t_a];
    else
      n_j = 50; t_j = linspace(t_b, t_99, n_j);
      n_a = 0;
      t = [t_e t_j];
    end
    
    %% -, scaled embryo E and L
    el3_0 = el3_init(f,g,l_b);     % -, scaled initial reserve
    haz = lsode('dhaz', [el3_0, 1e-4, 0, 0, 1, 0], t); 
    %% haz(:,1)=el^3, haz(:,2)=l, haz(:,3)=\int l^3 dt, haz(:,4)=h
    %% haz(:,5)=S, haz(:,6)=\int S dt
    %% e: scaled reserve density       l: scaled length
    %% h: hazard rate                  S: survival probability
    L = L_m*haz(:,2);        % set lengths
    [p e_ pC] = power(haz(:,2), f);  % get powers for calculated lengths
    M_V = L.^3*d_O(2)/w_O(2); % structural masses
    JO = p*eta_O';           % organic fluxes
    JM = JO*O2M;             % mineral fluxes
    J_O = -JM(:,3);          % minus dioxygen flux
    n = n_e + n_j + n_a; dt = [0,t(2:n) - t(1:n-1)]'; % time steps

    haz(:,4) = hT_a*cumsum(dt.*cumsum(dt.*J_O))./M_V;  
    haz(:,5) = exp(-cumsum(dt.*haz(:,4))); % crude way of calculating
					   % multiple integrals

    %% actual plotting
    if t_p < t_99
      plot(t_e, haz(1:n_e, 5), 'r', t_j, haz(n_e + (1:n_j), 5), 'b', ...
          t_a, haz(n_e + n_j + (1:n_a), 5), 'g');
    else
      plot(t_e, haz(1:n_e, 5), 'r', t_j, haz(n_e + (1:n_j), 5), 'b');
    end
			
    f = f - 0.2;        % -, decrease functional response
    l_i = f - l_h;      % -, new ultimate scaled length
  end

