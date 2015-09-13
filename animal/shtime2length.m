function shtime2length
  %% created 2000/09/05 by Bas Kooijman, modified 2009/08/01
  %% plot lengths as a function of time
  
  global L_m kT_M eb_min a_m u_Hp u_Hb
  global hT_a s_G v_Hb v_Hp k g l_T  % for get_leh
  

  hold on;
  
  pars_leh = [g; k; l_T; v_Hb; v_Hp; hT_a/ kT_M^2; s_G]; % collect parameters  
  f = 1;                % -, initiate scaled functional response
    
  while f > eb_min(2)   % f at which maturation ceases at birth
    
    t = linspace(0, 3 * a_m * kT_M, 100)';
    leh = get_leh(t, pars_leh, f); % scaled length l, reserve u_E, maturity u_H 

    a = t/ kT_M;      % d, convert scaled time to real time
    L = L_m * leh(:,1); % cm, structural length
    
    sel_embryo = leh(:,3) < u_Hb;
    sel_juvenile = and(leh(:,3) >= u_Hb, leh(:,3) < u_Hp);
    sel_adult = leh(:,3) >= u_Hp;
    
    %% actual plotting
    if sum(sel_embryo) > 0
      plot(a(sel_embryo), L(sel_embryo), 'b')
    end
    if sum(sel_juvenile) > 0
      plot(a(sel_juvenile), L(sel_juvenile), 'g')
    end
    if sum(sel_adult) > 0
      plot(a(sel_adult), L(sel_adult), 'r')
    end

    f = f - 0.2;        % -, decrease functional response
  end

  title ('structural lengths for f = 1, 0.8, 0.6, ..');
  xlabel('time, d'); ylabel('length, mm');

