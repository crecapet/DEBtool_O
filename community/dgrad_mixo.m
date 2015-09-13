function dX = dgrad_mixo (X_t, t)
  %% dX = dgrad_mixo (X_t, t)
  %% created: 2002/03/15 by Bas Kooijman
  %% routine called from shgrad_mixo
  %% Differential equations for closed mixotroph system with vertical gradient

  global upmix dwnmix nL nX Lh j_L_F 

  dX = zeros(nL*nX,1); % initiate state derivatives
  %% j_L_F = j_L_F * max(0, pi * sin(2*pi*t));  % diurnic forcing, t in days
  %%   the cyclic forcing factor equals 1 on average 

  %% surface layer (no light correction)
  dX(1:nX) = dstate0(X_t(1:nX),t) - ...  %% local change
    dwnmix .* X_t(1:nX) +  ...            %% down flux
    upmix .* X_t(nX + (1:nX));            %% up flux

  %% deeper layers
  for i = 2: (nL-1)
    j_L_F = j_L_F/ e^(1/Lh);             %% light correction
    dX((i-1)*nX + (1:nX)) = dstate0(X_t((i-1)*nX + (1:nX)),t) - ...
      (upmix + dwnmix) .* X_t((i-1)*nX + (1:nX)) +  ...
      upmix .* X_t(i*nX+(1:nX)) + dwnmix .* X_t((i-2)*nX + (1:nX));
  end

  %% bottum layer
  j_L_F = j_L_F/ e^(1/Lh);               %% light correction
  dX((nL-1)*nX + (1:nX)) = dstate0(X_t((nL-1)*nX + (1:nX)),t) - ...
    upmix .* X_t((nL-1)*nX + (1:nX)) +  ...
    dwnmix .* X_t((nL-2)*nX + (1:nX));
