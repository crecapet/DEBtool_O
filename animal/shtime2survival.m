function shtime2survival
  %% created 2000/09/05 by Bas Kooijman, modified 2011/02/03
  %% plot survival as a function of time for various f's

  global hT_a s_G vHb vHp k g l_T f  % to dget_tm
  global eb_min a_m vT kT_M kT_J v_Hb v_Hp % from pars_animal
  
  hold on;
  
  vHb = v_Hb; vHp = v_Hp;
  L_m = vT/ g/ kT_M; k = kT_J/ kT_M;
  Lv = vT/ kT_M; ht = hT_a/ kT_M^2; % for export to fnlifespan
 
  f = 1;                            % -, scaled functional response
  
  while f > eb_min(2) % f large than ceasing growth at birth
    [uE0 lb info] = get_ue0([g, kT_J/ kT_M, v_Hb], f); % scaled intial reserve
    if info ~= 1
      fprintf('warning: no convergence for uE0 \n');
    end
  
    x0 = [lb/1000; uE0; 1e-12; 0; 0; 1; 0];
    t = linspace(0, 3 * a_m * kT_M, 100)';
    x = lsode('dget_tm', x0, t);           
    t = t/ kT_M;  % convert mean to real time
  
    sel_embryo = (x(:,3) < v_Hb);
    sel_juvenile = and((x(:,3) > v_Hb),(x(:,3) < v_Hp));
    sel_adult = (x(:,3) > v_Hp);

    if sum(sel_embryo) > 0
      plot(t(sel_embryo), x(sel_embryo, 6), 'b')
    end
    if sum(sel_juvenile) > 0
      plot(t(sel_juvenile), x(sel_juvenile, 6), 'g')
    end
    if sum(sel_adult) > 0
      plot(t(sel_adult), x(sel_adult, 6), 'r')
    end
    
    f = f - 0.2;        % -, decrease functional response
  end    
  title ('survival probability for f = 1, 0.8, 0.6, ..');
  xlabel('time, d'); ylabel('survival probability');
  