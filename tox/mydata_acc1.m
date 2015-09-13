%% test hypothesis that elim. rates in two accumulation curves differ

tc1 = [0 1 2 3 4 5; 0, 3.1 5.9 8.1 9. 9.5]'; % data 1:time, internal conc.
tc2 = [0 1 2 3 4 5; 0, 2.9, 5.7, 7.9 8.9 9.4]'; % data set 2

%% Define model for equal elim rates
function f = myacc0(p,tc)
  K = p(1); ke = p(2);
  f = K*(1-exp(-tc(:,1)*ke));
endfunction

%% get parameters, sd  and show them
p0 = nrregr('myacc0',[10 .3]',[tc1;tc2]);
[cov0,cor0,sd0] = pregr('myacc0',p0,[tc1;tc2]);
[p0 sd0]
ssq0 = ssq('myacc0',p0,[tc1;tc2]);
%% plot data and curv
shregr('myacc0',p0, [tc1;tc2]); pause(1)

%% Define model for unequal elim rates
function [f1,f2] = myacc1(p,tc1,tc2)
  K = p(1); ke1 = p(2); ke2 = p(3);
  f1 = K*(1-exp(-tc1(:,1)*ke1));
  f2 = K*(1-exp(-tc2(:,1)*ke2));
endfunction

%% get parameters, sd  and show them 
p1 = nrregr('myacc1',[15 .3 .3]', tc1, tc2);
[cov1,cor1,sd1] = pregr('myacc1',p1, tc1, tc2);
[p1 sd1]
ssq1 = ssq('myacc1',p1, tc1, tc2);
shregr_options('default'); % reset options
shregr_options('all_in_one',1); % single plot-option
shregr('myacc1',p1, tc1, tc2);

2*log(ssq0/ssq1)
