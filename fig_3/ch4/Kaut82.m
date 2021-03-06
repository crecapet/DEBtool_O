%% fig:Kaut82
%% bib:Kaut82
%% out:Kaut82
%% Growth at changing temperature in Mytilus edulis

tL4= [500.7596   33.0607;
      435.8874   32.6634;
      396.7994   31.9766;
      353.5979   31.1479;
      311.4407   29.8347;
      244.9528   29.1244;
      164.4060   28.9172;
      114.5975   28.5144;
      64.0535    27.8111;
       7.8439    26.0399];

tL3 = [500.7596   27.9429;
       435.8874   26.9211;
       396.7994   25.3762;
       353.5979   23.8539;
       311.4407   21.7285;
       244.9528   20.8252;
       164.4060   20.1295;
       114.5975   19.8195;
        64.0535   18.9774;
         7.8439   17.1020];

tL2 = [500.7596   24.1927;
       435.8874   23.0435;
       396.7994   21.6613;
       353.5979   19.1658;
       311.4407   16.8218;
       244.9528   15.1261;
       164.4060   14.9202;
       114.5975   14.5056;
        64.0535   12.8522;
         7.8439   10.5026];

tL1 = [500.7596   20.9616;
       435.8874   19.2787;
       396.7994   17.7228;
       353.5979   14.9382;
       311.4407   11.8061;
       244.9528    9.7879;
       164.4060    9.5112;
       114.5975    9.2836;
        64.0535    7.8032;
         7.8439    5.6143];

tTemp = [ ...
    1.6704    4.6985;
    9.5208   10.6264;
   15.7600    8.2358;
   25.2173   10.4867;
   33.2669   15.9703;
   41.1458    8.3450;
   48.5540    9.9537;
   64.0885    7.8662;
   73.1408    7.8009;
   79.8376    8.0605;
   89.3649    7.7857;
   93.4609    7.2897;
  101.6003    6.3197;
  114.2713    5.9681;
  118.6410    5.7067;
  126.4148    5.1360;
  138.7815    3.8483;
  151.6539    3.4084;
  158.9680    3.1585;
  168.6202    2.8287;
  179.5617    2.5259;
  186.3986    2.4856;
  195.8186    2.3773;
  200.9173    1.7961;
  205.9568    1.7155;
  212.5681    1.4184;
  220.1493    1.8816;
  225.4231    1.5793;
  233.4902    1.7106;
  249.9398    1.9522;
  261.3323    2.5192;
  263.5150    2.9839;
  269.7345    3.4529;
  281.8429    6.4374;
  303.0036    9.0006;
  307.6096    9.5860;
  319.4115   10.2102;
  322.1261    8.1843;
  327.2904   13.1560;
  335.2394   12.8640;
  341.9427   13.0012;
  348.7883   12.8385;
  357.2955   11.4693;
  376.9544   16.1186;
  377.5915   17.5010;
  384.5618   16.9270;
  389.1788   14.0628;
  394.6693   13.0713;
  412.6316    7.4212;
  429.0724    7.4291;
  433.9434    6.2349;
  443.4401    7.1619;
  444.5018    6.9324;
  458.8126    7.5217;
  466.3675    6.9278;
  473.8895    6.4672;
  486.2891    4.3341;
  494.1702    3.5968;
  503.2203    2.8195];

function dlt = growth(lt)
  global TA T0 g kM kf kT
  l = lt(1); t = lt(2); % unpack state variables
  %% we append a dummy variable to prevent lsode
  %%   to make big steps if dl == 0 for too long
  f = spline(t, kf); T = 273 + spline(t, kT);
  %% see eq (7.1) {225}
  if T > T0 & f > l
    k = g * kM * exp(TA/ 288 - TA/ T)/ 3;
    dl = k * (f - l)/ (f + g); dlt = [dl; 1; t/1000];
  else 
    dl = 0; dlt = [dl; 1; t/1000];
  end
endfunction

function [L1, L2, L3, L4] = tgrowth(p, tL1, tL2, tL3, tL4)
  global TA T0 g kM kf kT
  %% unpack parameters
  TA = p(1); T0 = p(2); Lm = p(3); g = p(4); kM = p(5);
  L10 = p(6); L20 = p(7); L30 = p(8); L40 = p(9); % initial lengths
  kf = [kT(:,1), p(10:14)]; % knots for func response

  L1 = Lm * lsode('growth', [L10/ Lm; 0; 0], tL1(:,1)); L1 = L1(:,1);
  L2 = Lm * lsode('growth', [L20/ Lm; 0; 0], tL2(:,1)); L2 = L2(:,1);
  L3 = Lm * lsode('growth', [L30/ Lm; 0; 0], tL3(:,1)); L3 = L3(:,1);
  L4 = Lm * lsode('growth', [L40/ Lm; 0; 0], tL4(:,1)); L4 = L4(:,1);
endfunction

global kT
t = linspace(0,520,100)'; % time axis for plotting
%% append extra 'data point' to force levelling of spline
kT = knot([0 50 250 350 450]',[tTemp; 550 5]); % knots of cubic spline
tT = [t, spline(t, kT)]; % smoothed temperatures

par_txt = {'Arr temp', 'threshold temp'; 'max length'; ...
	   'investm ratio'; 'maint rate coeff'; ...
	   'initial length 1'; 'initial length 2'; ...
	   'initial length 3'; 'initial length 4'; ...
	   'f-knot 0'; 'f-knot 50'; 'f-knot 250'; 'f-knot 350'; 'f-knot 450'};
p = [7600 0; 278 0; 100 0; 0.13 0; 0.03 0; ...
     5 1; 10 1; 17 1; 26 1; ... % initial lengths
     .33 1; .45 1; .1 1; .74 1; .45 1]; % knots for functional response
%% p = nmregr('tgrowth', p, tL1, tL2, tL3, tL4);
%% [cov cor sd] = pregr('tgrowth', p, tL1, tL2, tL3, tL4);
%% printpar(par_txt, p ,sd)

[L1, L2, L3, L4] = tgrowth(p(:,1), t, t, t, t);
kf = [kT(:,1), p(10:14,1)]; % knots of function responses
tf = [t, spline(t, kf)]; % functional responses

hold on;
plot([0;1], [0;0], 'g', t, L1, '-b', tTemp(:,1), tTemp(:,2), '-r', ...
     tT(:,1), tT(:,2), '-r', ...
    tL1(:,1), tL1(:,2), '.b', tL2(:,1), tL2(:,2), '.b', ...
    tL3(:,1), tL3(:,2), '.b', tL4(:,1), tL4(:,2), '.b', ...
    t, L2, '-b', t, L3, '-b', t, L4, '-b')
legend('func resp', 'length', 'temp', 2);
xlabel('time, d');
ylabel('temp, C; length, mm');

[AX, H1, H2] = plotyy(0, 0, tf(:,1), tf(:,2));
set(get(AX(2), 'YLabel'), 'String', 'scaled func response');
set(H2, 'LineStyle', '-'); set(H2, 'Color', 'g');
%% Legend: 'func resp' axis x1y2
%% set key 100, 34

