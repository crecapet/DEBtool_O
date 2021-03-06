function dX = dmarep(X, t)
  %% dX = dmarep(X, t)
  %% created 2002/01/20 by Bas Kooijman,
  %%  modified 2006/10/07; 2007/07/10; 2007/09/14
  %% routine called by marep; similar to dmagrowth, extended with reprod
  %% maintenance effects on reproduction of ectotherm: target [J_EM], [J_EJ]
  %% spec maint costs linear in internal concentration
  %% X: (5 * nc,1) vector with state variables (see below)
  %% t: exposure time (not used)
  %% dX: derivatives of state variables

  global C nc c0 cM ke kap kapR g kJ kM v Hb Hp
  global Lb0

  %% unpack state vector
  N = X(1:nc);        % cumulative number of offspring
  H = X(nc+(1:nc));   % scaled maturity H = M_H/ {J_EAm}
  L = X(2*nc+(1:nc)); % length
  U = X(3*nc+(1:nc)); % scaled reserve U = M_E/ {J_EAm}
  c = X(4*nc+(1:nc)); % scaled internal concentration
  
  s = max(0,(c - c0)/ cM);  % stress function
  %% we here apply the factor (1 + s) to k_M and kJ
  kMs = kM * (1 + s); kJs = kJ * (1 + s);

  E = U * v ./ L .^ 3;        % scaled reserve density e = m_E/m_Em (dim-less)
  %% again we scale with respect to m_Em = {J_EAm}/ (v [M_V]) of the blanc

  Lm = v/ (kM * g);           % maximum length in blank
  Lms = v./ (kMs * g);         % maximum length in stressed situation
  eg = E .* g ./ (E + g);      % in DEB notation: e g/ (e + g)
  SC = L .^ 2 .* eg .* (1 + L ./ (g .* Lms)); % SC = J_EC/{J_EAm}

  rBs = kMs * g ./ (3 * (E + g)); % von Bert growth rate
  dL = rBs .* (E .* Lms - L);   % change in length
  dU = L .^2 - SC;              % change in time-surface U = M_E/{J_EAm}
  dc = (ke * Lm .* (C - c) - 3 * dL .* c) ./ L; % change in scaled int. conc

  U0 = 0 * N; % initiate scaled reserve of fresh egg
  for i = 1:nc
    p_U0 = [Hb/ (1 - kap); g; kJs(i); kMs(i); v];
    [U0(i), Lb0(i)] = initial_scaled_reserve(1, p_U0, Lb0(i));
  end
  R = ((1 - kap) * SC - kJs * Hp) * kapR ./ U0; % reprod rate in %/d
  R = (H > Hp) .* max(0,R); % make sure that R is non-negative
  dH = (1 - kap) * SC - kJs .* H; % change in scaled maturity H = M_H/ {J_EAm}
  dX = [R; dH; dL; dU; dc]; % catenate derivatives in output
