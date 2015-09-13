function [c info] = fnLC50 (p,t)
  %% [c info] = fnLC50 (p, tLC50)
  %% created 2008/10/09 by Bas Kooijman
  %% p: 3-vector with NEC, killing rate, elim rate
  %% t: scaler with time
  %% c: scalar with LC50

  C0 = p(1); Bk = p(2); Ke = p(3);
  c0 = 1E-8 + C0/ (1 - exp(-Ke*t)); % initial estimate for Bk large
  c = c0;
  f = 1; i = 1;
  while (i <= 100) && (f^2 >= 1e-20) % Newton Raphson with boundary
    t0 = - log(1 - C0/ c)/ Ke;
    eKt0 = exp(-Ke * t0); eKt = exp(-Ke * t);
    f = log(2) + c * (eKt0 - eKt) * Bk/ Ke - ...
        Bk * (c - C0) * (t - t0);
    dt0 = C0/ c^2/ Ke/ (1 - C0/c);
    df =  (eKt0 - eKt) * Bk/ Ke - c * Bk * dt0 * eKt0 - ...
        Bk * (t - t0 - (c - C0) * dt0);
   %% [i f c t0 df dt0]
   c = max(c0, c - f/ df);
   i = i + 1;
  end
  if i == 100
    info = 0;
    fprintf('warning: no convergence\n');
  else
    info = 1;
  end
