function shphase_el(F,d)
  %% created 2000/09/05 by Bas Kooijman, modified 2009/08/01
  %% shows phase diagram of e and l, cf shphase_memv
  %% calls for fnel
  %% F: scalar with functional response
  %% d: scalar with multiplier for directionfield
  %% shrinking should be faster than indicated here cf {231}

  global kT_M g v_Hb k l_T kap f

  if exist('d', 'var') == 0
    d = .4;
  end
  if exist('F', 'var') == 0
    F = .7;
  end
  
  f = F; % % make func response available for fnel
  
  l_b = get_lb([g; k; v_Hb], f);
  
  l = linspace(.01, .99, 30)';
  %% truncate direction field to avoid problems with vector plotting
  dirf_el = max(-.1,dirfield('fnel', l, l, d)); % direction field

  el = [1 0; 1 1; 0 1];    % border
  e0 = [1e-4 0; 1e-4 l_b; f l_b;f 1];  % isocline d/dt e = 0
  l0 = [0, -l_T; 1, 1 - l_T];          % isocline d/dt l = 0
  lb = [0 l_b; 1 l_b];                 % embryo/juvenile transition
  
  l = linspace(0, 1, 100)';
  ld = [kap * g * l ./ (g + (1 - kap) * l + l_T), l]; % death/alive transition
  
  hold on;
  
  %% xrange [0:1]
  %% yrange [0:1]
  plot(el(:,1), el(:,2), '-m') % border
  plot(e0(:,1), e0(:,2), '-r', l0(:,1), l0(:,2), '-r') % isoclines
  plot(lb(:,1), lb(:,2), '-g', ld(:,1), ld(:,2), '-g') % embryo/juvenile, death/alive transition
  plot_vector(dirf_el, '-k') % attemps specification of linetype gives crashes
  plot(dirf_el(:,1), dirf_el(:,2),'.b')
  title(['phase diagram for f = ', num2str(f)])
  ylabel('scaled length, l')
  xlabel('scaled res density, e')
