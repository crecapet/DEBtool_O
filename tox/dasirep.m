function dX = dasirep(X, t)
  %% dX = dasirep(X, t)
  %% created 2002/02/18 by Bas Kooijman; modified 2007/07/10; 2007/09/14
  %% routine called by asirep
  %% assimilation effects on reproduction: target is {J_EAm}
  %% X: (4*nc,1) vector with state variables (see below)
  %% t: exposure time (not used)
  %% dX: derivatives of state variables

  global C nc c0 cA kap kapR g kJ kM v Hb Hp U0

  %% unpack state vector
  N = X(1:nc);        % cumulative number of offspring
  H = X(nc+(1:nc));   % scaled maturity H = M_H/ {J_EAm}
  L = X(2*nc+(1:nc)); % length
  U = X(3*nc+(1:nc)); % scaled reserve U = M_E/ {J_EAm}
  
  s = min(.99999,max(0,(C - c0)/ cA)); % stress function
  %% we here apply the factor (1 - s) to {J_EAm}

  %% although U = M_E/{J_EAm}, we scale with {J_EAm} of the blanc
  %% this also applies to SC = J_EC/{J_EAm}

  E = U * v ./ L .^ 3;        % scaled reserve density e = m_E/m_Em (dim-less)
  %% again we scale with respect to m_Em = {J_EAm}/ (v [M_V]) of the blanc

  %% since g = v [M_V]/(\kap {J_EAm} y_VE) we have
  gs = g ./ (1 - s);          % stressed value for energy investment ratio

  Lm = v/ (kM * g);           % maximum length in blank
  Lms = v ./ (kM * gs);       % maximum length in stressed situation
  eg = E .* gs ./ (E + gs);   % in DEB notation: e g/ (e + g)
  SC = L .^ 2 .* eg .* (1 + L ./ (gs .* Lms)); % SC = J_EC/{J_EAm}

  rBs = kM * gs ./ (3 * (E + gs)); % von Bert growth rate
  dL = rBs .* (E .* Lms - L);    % change in length
  dU = (1 - s) .* L.^2 - SC;     % change in time-surface U = M_E/{J_EAm}

  R = ((1 - kap) * SC - kJ * Hp) * kapR ./ U0; % reprod rate in %/d
  R = (H > Hp) .* max(0,R); % make sure that R is non-negative
  dH = (1 - kap) * SC - kJ * H; % change in scaled maturity H = M_H/ {J_EAm}
  dX = [R; dH; dL; dU]; % catenate derivatives in output
