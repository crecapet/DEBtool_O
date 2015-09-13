function [W O2 Tb] = embryo_lT(p, aW, aO2)
  global TA Ti Te rBi TM TG T

  %% unpack parameters
  TA = p(1); %% Arrhenius temp
  Ti = p(2); %% ultimate body temp
  Te = p(3); %% environmental temp
  rBi = p(4); %% von Bert growth at Ti
  %% for p_TM* and p_TG* given in the comments of fnembryo_l
  TM = p(5); %% contrib of maint in heating: p_TM* alpha_T/k_be
  TG = p(6); %% contrib of growth in heating: p_TG* alpha_T/k_be
  d = p(7); %% wet body weight if l = 1;
  l0 = p(8); %% initial scaled length
  bM = p(9); %% contrib of maint in respiration
  bG = p(10); %% contrib of growth in respiration
    
  l = lsode('fnembryo_l', l0, [0;aW(:,1)]); l(1) = [];
  W = d * l(:,1).^3;
  
  l = lsode('fnembryo_l', l0, [0;aO2(:,1)]); l(1) = [];
  [nO2 k ] = size(aO2); Tb = zeros(nO2,1); Tb0 = Ti;
  for i = 1:nO2
    T = l(i)^2 * (TM * l(i) + TG * 3 * rBi * (1 - l(i)));
    Tb(i) = fsolve('fnembryo_T',Tb0); Tb0 = Tb(i); % continuation
  end
  
  k = exp(TA/Ti - TA ./Tb); %% see {137}
  O2 = k .* l.^2 .* (bG * 3 * rBi .* ( 1 - l) .*  + bM .* l);
