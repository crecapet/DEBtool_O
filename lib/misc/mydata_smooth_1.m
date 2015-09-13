%% example of the use of smoothing functions:
%%   interpolation, roots, extremes, integration, derivation, second derivation
%% Bas Kooijman, modified 2011/07/02

%% set data for period 365 d
  ty = [ (0:8)', (0:8)'];

t = linspace(0,8,100)'; % time points for evaluation

%% spline1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[fs1, dfs1] = spline1(t, ty); % function values and derivative
ifs1 = ispline1(t, ty); % integration

%% spline, here natural spline. Can also be clamped %%%%%%%%%%%%%%%%%%%%%%%%%%

[fs, dfs, ddfs] = spline(t, ty); % function values and derivatives
ifs = ispline(t, ty); % integration


%% fnfourier for periodic fns; derivative at start and end period are equal 

%% get Fourier coefficients with 4 terms, s0 1 + 2 * 4 = 9 pars
p = get_fourier(365, 3, ty); % 365 = period (days), 

ff = fnfourier(t, p);  % function values
iff = ifnfourier(t,p);  % integral

T = [0:2:8]';
[T ispline1(T, ty) ispline(T, ty)]

%% plotting %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

subplot(2,2,1)
plot(ty(:,1), ty(:,2), 'ok', t, fs1, 'b')
xlabel('independent var')
ylabel('dependent var')
title('first order spline')

subplot(2,2,2)
plot(ty(:,1), ty(:,2), 'ok', t, fs, 'r')
xlabel('independent var')
ylabel('dependent var')
title('cubic spline')

subplot(2,2,3)
plot(ty(:,1), ty(:,2), 'ok', t, ff, 'g')
xlabel('independent var')
ylabel('dependent var')
title('Fourier series')

subplot(2,2,4)
plot(t, ifs1, 'b', t, ifs, 'r', ... % t, iff,'g',...
      [0 3 3]', [4.5 4.5 0]', 'm', ...
      [0 5 5]', [12.5 12.5 0]', 'm')
xlabel('independent var')
ylabel('integrated')

