function f_R = fnget_eb_min_R(uE0,x)
  
  global par_eb_min ulv_stop test
 
  vHb = par_eb_min(3);
  
  test = 0; % flag set to 1 if d/dt v_H == 0; emulation of event handler
  ulv_stop = [0; 0; 0]; % initiate ulv for which dv = 0
  ulv = lsode(@dget_ulv, [uE0; 5e-3; 0], linspace(0, 50, 100)'); % fills ulv_stop

  f_R = ulv_stop(3) - vHb;
  % uEb = ulv_stop(1); lb = ulv_stop(2); 

  if test == 0
    fprintf('get_eb_min_R warning: maturity did not cease\n');
  end
    