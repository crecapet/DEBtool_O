function [W WH lnLH] = body_heart(p, tW, tWH, lnLLH)
  global  Lh v kM kMH d dH
  
  %% unpack p
  L0 = p(1); del = p(2); Lh = p(3); v = p(4);
  kM = p(5); kMH = p(6); d = p(7); dH = p(8);
  a = p(9); b = p(10);

  L0H = del * L0;
  
  t = tW(:,1); tH = tWH(:,1); % t = tH in these data sets
  WWH = lsode('dbody_heart', [L0^3, L0H^3], tH);
  W = sum(WWH,2); WH = WWH(:,2);

  %% allometric regression of LH on L
  lnLH = a + b * log10(W .^ (1/3));
