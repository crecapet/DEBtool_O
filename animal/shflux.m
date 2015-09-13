function shflux (j)
  %% created 2000/09/07 by Bas Kooijman, modified 2009/07/29
  %% flux plots for 'animal'

  global eta_O n_O n_M eb_min g k l_T v_Hb v_Hp p_ref
  global L_m L_T vT kT_M kT_J kap kap_R U_Hb U_Hp

  f = 1;              % -, scaled functional response
  O2M = (- n_M\n_O)'; % -, matrix that converts organic to mineral fluxes
			               	% O2M is prepared for post-multiplication
  pars_lp = [g; k; l_T; v_Hb; v_Hp];
  pars_power = [kap; kap_R; g; kT_J; kT_M; L_T; vT; U_Hb; U_Hp];
  
  txt =   {'food mol/d'; 'structure mol/d';
	       'reserve mol/d'; 'faeces mol/d'; 
           'carbon dioxyde mol/d';'water mol/d';
	       'dioxygen mol/d';'ammonia mol/d'};

  if exist('j', 'var') ~= 1
    handle = zeros(8,1);
    for i = 1:8 
        handle(i) = figure(i);
    end
  end
  
  while f > eb_min(2)  
        
    [l_p l_b] = get_lp(pars_lp, f);
    l = linspace(1e-4, f - l_T, 100)';
        
    %% actual plotting
    sel_embryo = l < l_b;
    sel_juvenile = and(l >= l_b, l < l_p);
    sel_adult = l >= l_p;
    %% scaled lengths for embryo, juvenile and adult
    
    pACSJGRD = p_ref * scaled_power(l * L_m, f, pars_power, l_b, l_p);
    pADG = pACSJGRD(:, [1 7 5]);
    
    JO = pADG * eta_O';        % organic fluxes
    JM = JO * O2M;             % mineral fluxes
    J = [JO, JM];
 
    if exist('j', 'var') == 1 % single-plot mode
      plot(l(sel_embryo), J(sel_embryo,j), 'b', ... 
         l(sel_juvenile), J(sel_juvenile,j), 'g', ... 
         l(sel_adult), J(sel_adult,j), 'r')
      ylabel(txt{j}); xlabel('scaled length');
      title('total flux for f = 1, .8, ..')
      hold on  
    else % multiple plot-mode
      for i = 1:8
        set(0,'CurrentFigure',handle(i))
        plot(l(sel_embryo), J(sel_embryo,i), 'b', ... 
           l(sel_juvenile), J(sel_juvenile,i), 'g', ... 
           l(sel_adult), J(sel_adult,i), 'r')
        ylabel(txt{i}); xlabel('scaled length');
        title('total flux for f = 1, .8, ..')
        hold on
      end 

    end
    f = f - 0.2;               % -, decrease functional response
  end
