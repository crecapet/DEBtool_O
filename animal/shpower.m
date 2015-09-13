function shpower (j)
  %% created 2000/10/03 by Bas Kooijman, modified 2009/07/29
  %% power plots for 'animal'

  global eb_min g k l_T v_Hb v_Hp p_ref mu_O mu_M n_O n_M eta_O d_O w_O m_Em
  global L_m L_T vT kT_M kT_J kap kap_R U_Hb U_Hp

  f = 1;              % -, scaled functional response
  pars_lp = [g; k; l_T; v_Hb; v_Hp];
  pars_power = [kap; kap_R; g; kT_J; kT_M; L_T; vT; U_Hb; U_Hp];
  
  txt =   ['dissipating heat, J/d'; 
           'assimilation power, J/d';
	       'dissipation power, J/d';
           'growth power, J/d';
           'spec dissipating heat, J/d.g'; 
           'spec assimilation power, J/d.g';
	       'spec dissipation power, J/d.g';
           'spec growth power, J/d.g';
           ];

  if exist('j', 'var') ~= 1
    handle = zeros(8,1);
    for i = 1:8 
        handle(i) = figure(i);
    end
  end
  
  while f > eb_min(2)  
        
    [l_p l_b] = get_lp(pars_lp, f);
    l = linspace(l_b, f - l_T, 100)';
        
    %% actual plotting
    sel_embryo = l < l_b;
    sel_juvenile = and(l >= l_b, l < l_p);
    sel_adult = l >= l_p;
    %% scaled lengths for embryo, juvenile and adult
    
    pACSJGRD = p_ref * scaled_power(l * L_m, f, pars_power, l_b, l_p);
    pADG = pACSJGRD(:, [1 7 5]); % assimilation, dissipation, growth
    pT = pADG * eta_O' * ((n_M\n_O) * mu_M  - mu_O); % dissipating heat
    W = (L_m * l) .^ 3 * d_O(2)* (1 + f * m_Em * w_O(3)/ w_O(2));
    P = [pT, pADG, pT ./ W, pADG ./ [W, W, W]];
 
    if exist('j', 'var') == 1 % single-plot mode
      plot(l(sel_embryo), P(sel_embryo,j), 'b', ... 
         l(sel_juvenile), P(sel_juvenile,j), 'g', ... 
         l(sel_adult), P(sel_adult,j), 'r')
      ylabel(txt(j,:)); xlabel('scaled length');
      title('total flux for f = 1, .8, ..')
      hold on  
    else % multiple plot-mode
      for i = 1:8
        set(0,'CurrentFigure',handle(i))
        plot(l(sel_embryo), P(sel_embryo,i), 'b', ... 
           l(sel_juvenile), P(sel_juvenile,i), 'g', ... 
           l(sel_adult), P(sel_adult,i), 'r')
        ylabel(txt(i,:)); xlabel('scaled length');
        title('heat and powers for f = 1, .8, ..')
        hold on
      end 

    end
    f = f - 0.2;               % -, decrease functional response
  end
  
