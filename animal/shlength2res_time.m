function shlength2res_time
  %% shresidence_time
  %% created 2009/01/15 by Bas Kooijman, modified 2009/07/29


  global kT_M g l_T 
  
  hold on

  for f = 0.2:0.2:1

    l = linspace(1e-4, f, 50 * f)';
    t_E = res_time(l, f, [kT_M; g; l_T]);

    plot(l, t_E, 'r')
  end
  title('f = 1, .8, ., .2')
  xlabel('scaled length')
  ylabel('reserve residence time, d')