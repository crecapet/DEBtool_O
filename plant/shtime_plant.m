function shtime_plant (j)
  %% shtime_plant (j)
  %% created: 2000/09/26 by Bas Kooijman; modified 2009/02/20
  %% time_plots for 'plant'
  global X T_1 T_A T_L T_H T_AL T_AH n_N_ENR n_N_ER ...
    M_VSd M_VSm M_VRd M_VRm M_VSb M_VRb M_VSp M_ER0 ...
    k_C k_O k_ECS k_ENS k_ES k_ECR k_ENR k_ER rho_NO ...
    J_L_K K_C K_O K_NH K_NO K_H ...
    j_L_Am j_C_Am j_O_Am j_NH_Am j_NO_Am ...
    y_ES_CH_NO y_CH_ES_NO y_ER_CH_NO y_CH_ER_NO y_ER_CH_NH ...
    y_VS_ES y_ES_VS y_VR_ER y_ER_VR y_ES_ER y_ER_ES ...
    y_ES_ENS y_ENS_ES y_ER_ENR y_ENR_ER y_ENS_ENR y_ECR_ECS ...
    kap_ECS kap_ECR kap_ENS kap_ENR kap_SS ...
    kap_SR kap_RS kap_TS kap_TR ...
    j_ES_MS j_ER_MR j_ES_JS j_PS_MS j_PR_MR y_PS_VS y_PR_VR
 
  tmax = 500;  t = linspace (0, tmax, 100); % select time points
  
  %% State vector:
  %%   M = [M_PS, M_VS, M_ECS, M_ENS, M_ES, M_PR, M_VR, M_ECR, M_ENR, M_ER]
  %% initial value
  M0 = [0, 1e-4, 1e-4, 1e-4, 1e-4, 0, 1e-4, 1e-4, 1e-4, M_ER0]';
  Mt  = lsode ('flux', M0, t); % integrate

  if exist ('j', 'var') == 1 % single plot mode

    switch j
      case 1
        xlabel('time, d'); ylabel('structures, mol'); 
        plot (t, Mt(:,2), 'g', t, -Mt(:,7), 'r', [0, tmax], [0, 0], '8');
      case 2
        xlabel('time, d'); ylabel('products, mol');
        plot (t, Mt(:,1), 'g', t, -Mt(:,6), 'r', [0, tmax], [0, 0], '8');
      case 3
        xlabel('time, d'); ylabel('reserves, mol');
        plot (t, Mt(:,3), '6', t, Mt(:,4), 'b', t, Mt(:,5), 'r', ...
	      t,-Mt(:,8), '6', t,-Mt(:,9), 'b', t,-Mt(:,10), 'r', ...
	      [0, tmax], [0, 0], '8');
      case 4
        m_ECR = Mt(:,8)./Mt(:,7); m_ENR = Mt(:,9)./Mt(:,7);
        m_ER = Mt(:,10)./Mt(:,7); m_ERm = max([m_ECR; m_ENR]);
	
        xlabel('time'); ylabel('reserve densities, mol/mol');
        plot (t, Mt(:,3)./Mt(:,2), '6', t, Mt(:,4)./Mt(:,2), 'b', ...
	      t, Mt(:,5)./Mt(:,2), 'r', t, -m_ECR, '6', ...
	      t, -m_ENR, 'b', t, -min(m_ERm,m_ER), 'r', ...
	      [0, tmax], [0, 0], '8');
      otherwise
        return;
    end
   
  else % multiple plot mode
    subplot (2, 2, 1); 
       xlabel('time, d'); ylabel('structures, mol'); 
       plot (t, Mt(:,2), 'g', t, -Mt(:,7), 'r', [0, tmax], [0, 0], '8');

    subplot (2, 2, 2); 
       xlabel('time, d'); ylabel('products, mol');
       plot (t, Mt(:,1), 'g', t, -Mt(:,6), 'r', [0, tmax], [0, 0], '8');

    subplot (2, 2, 3);
      xlabel('time, d'); ylabel('reserves, mol');
      plot (t, Mt(:,3), '6', t, Mt(:,4), 'b', t, Mt(:,5), 'r', ...
  	    t,-Mt(:,8), '6', t,-Mt(:,9), 'b', t,-Mt(:,10), 'r', ...
     	[0, tmax], [0, 0], '8');

    subplot (2, 2, 4); 
      m_ECR = Mt(:,8)./Mt(:,7); m_ENR = Mt(:,9)./Mt(:,7);
      m_ER = Mt(:,10)./Mt(:,7); m_ERm = max([m_ECR; m_ENR]);
      xlabel('time'); ylabel('reserve densities, mol/mol');
      plot (t, Mt(:,3)./Mt(:,2), '6', t, Mt(:,4)./Mt(:,2), 'b', ...
        t, Mt(:,5)./Mt(:,2), 'r', t, -m_ECR, '6', ...
        t, -m_ENR, 'b', t, -min(m_ERm,m_ER), 'r', ...
        [0, tmax], [0, 0], '8');
    
  end
