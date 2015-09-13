function shthrou2graz (j)
  %% shthrou2graz (j)
  %% created 2000/10/25 by Bas Kooijman, modified 2009/02/20
  %% called from 'symbi' to show throughput/grazing profiles
  %%  in symbiosis
  %% State vector:
  %%   X_t = [X; X_N; X_CH; X_VA; m_EC; m_EN; X_VH; m_E]
  %%   X: substrate        X_N: nitrogen      X_CH: carbo-hydrate
  %%   X_VA: struc autotr  m_EC: C-res dens   m_EN: N-res density
  %%   X_VH: struc hetero  m_E: res density

  global X_R X_RN

  X_t = [X_R X_RN 0 1 1 1 1 1];
  [hb_VA, h_v, b_VAv] = ...
     varpar2 ('dX', X_t, 'h', 1e-3, .025, 8, 'b_VA', 1e-5, .002, 8);

  clf; 
  
  if exist('j', 'var')==1 % single plot mode
    switch j
 
      case 1
        xlabel('throughput'); ylabel('grazing'); zlabel('X_VA');
        mesh (h_v, b_VAv, hb_VA._4);

      case 2
        xlabel('throughput'); ylabel('grazing'); zlabel('X_VH');
        mesh (h_v, b_VAv, hb_VA._7);

      case 3
        xlabel('throughput'); ylabel('grazing'); zlabel('X_VA/X_VH');
        mesh (h_v, b_VAv, hb_VA._4 ./ hb_VA._7);

      otherwise
	return;
	
    end
  else % multiple plot mode
    %% top_title('Equilibria of auto -and heterotrophs and their ratio')

    subplot (1, 3, 1)
    xlabel('throughput'); ylabel('grazing'); zlabel('X_VA');
    mesh (h_v, b_VAv, hb_VA._4);

    subplot (1, 3, 2)
    xlabel('throughput'); ylabel('grazing'); zlabel('X_VH');
    mesh (h_v, b_VAv, hb_VA._7);

    subplot (1, 3, 3)
    xlabel('throughput'); ylabel('grazing'); zlabel('X_VA/X_VH');
    mesh (h_v, b_VAv, hb_VA._4 ./ hb_VA._7);
  end
