function f = accum(p, tc)
  %% tc(:,1) must be stricty increasing starting from 0     
  global ke BCF t0

  %% unpack parameters
  ke = p(1); BCF = p(2); t0 = p(3);
  f = lsode('daccum',[0 0]', [0; 1e-6+tc(:,1)]);
  nf = length(f); f = f(2:nf,1);
