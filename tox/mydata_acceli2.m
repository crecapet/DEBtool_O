global tc_knot

tCa = [ ...
	0.00 	     0;
	1.00 	  8.526;
	1.75  	 18.642;
	2.31 	 21.262;
	3.08 	  9.941;
	5.00 	 12.116;
	6.02 	 11.161;
	7.20 	30.112];

tCe = [ ...
7.2 	30.112;
8.00 	14.992;
9.00 	3.757;
9.92 	4.483;
11.90 	.347;
14.04 	.079;
16.18 	.239;
18.10 	.214;
18.79 	.070;
21.83 	.272];

tc_knot = [ ...
    0.00 	15.7;
	1.00 	11.1;
	1.75 	8.95;
	2.31 	8.65;
	3.08 	8.75;
	5.00 	8.05;
	6.02 	7.6;
	7.20 	7.8];
	
function df = dacc2a(C12,t)
  global k1 k2 k3 k4 tc_knot
  
  C1 = C12(1); C2 = C12(2);
  df = [k1 * spline(t,tc_knot) - k2 * C1 - k3 * C1 + k4 * C2;
	k3 * C1 - k4 * C2];
endfunction

function df = dacc2e(C12,t)
  global k2 k3 k4
  
  C1 = C12(1); C2 = C12(2);
  df = [ - k2 * C1 - k3 * C1 + k4 * C2;
	k3 * C1 - k4 * C2];
endfunction

function [Ca, Ce] = acceli2(p, tCa, tCe)
  global k1 k2 k3 k4
  
  %% unpack parameters
  k1 = p(1); k2 = p(2); k3 = p(3); k4 = p(4); w = p(5);
  
  %% accumulation
  C12a = lsode('dacc2a', [0 0]', tCa(:,1));
  Ca = w * C12a(:,1) + (1 - w) * C12a(:,2);
  %% elimination
  [nt nk] = size(C12a); C0 = C12a(nt,:)';
  C12e = lsode('dacc2e', C0, tCe(:,1)-tCe(1,1));
  Ce = w * C12e(:,1) + (1 - w) * C12e(:,2);
endfunction


%% t = linspace(0,7.2,100)'; c = spline(t, tc_knot);
%% gplot tc_knot w p 1, [t, c] w l 2

par = [2.245 1;.455 1; .001 0; .0001 0; .5 1];
par = nmregr('acceli2', par,tCa, tCe)

clf
shregr('acceli2', par, tCa, tCe);
