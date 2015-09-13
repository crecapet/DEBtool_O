% mydata_get_tb

par = [0.090; 0.01; 1e-2]; % g, k, v_Hb
eb = .8; % scaled reserve density at birth

[tb1 lb1 uE01 info1] = get_tb1(par, eb);
[tb lb info] = get_tb(par,eb);
uE0 = get_ue0(par, eb);

% compare results
[tb1 lb1 uE01 info1;
 tb  lb  uE0 info]