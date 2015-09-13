function t_m = lifespan (f,g,l_b,l_h,kT_M,hT_a)
  %% t_m = lifespan (f,g,l_b,l_h,kT_M,hT_a)
  %% created 2000/09/06 by Bas Kooijman
  %% calculates mean life span, supposing hardly any growth after t_i
  %%        applicable range for scaled functional response: f> l_b
  %% h(t) = h(t_i) + h_a*(t - t_i)*(1 + u_i*k_M + (t - t_i)*k_M/2)
  %%        with u_i = \int_0^t_i l^3(t)/l^3(t_i) dt
  %% S(t) = \int_0^t h(t_1) dt_1
  %%      = S(t_i)*exp(-(1+u_i*k_M)*(h_a/2)*(t-t_i)^2 - ...
  %%                    (h_a*k_M/6)*(t-t_i)^3)
  %% t_m = \int_0^\infty S(t) dt
  %%     = \int_0^t_i S(t) dt + S(t_i)*exp(-(1+(u_i+1/4)*k_M)*h_a/6)
 
  el3_0 = el3_init(f,g,l_b);    % -, scaled initial reserve
  t_b = incub(f,g,l_b,kT_M);    % d, time at birth
  r_B = kT_M/(3*(1 + f/g));     % 1/d, von Bert growth rate
  t_99 = t_b + log((f - l_b)/(((f-l_h)*0.01)))/r_B; 
		      % d, time to reach length 0.99*L_i ("fully" grown)

  haz= lsode('dhaz', [el3_0, 1e-4, 0, 0, 1, 0], [0, t_99]); 
  t_m = haz(2,6) + haz(2,5)*exp(-(1+(haz(2,3)+1/4)*kT_M)*hT_a/6);
