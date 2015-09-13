%% fig:juv
%% out:juv

%% effect of juvenile period and discrete reprod on spec growth rate

apR = linspace(0, 5, 100)'; % juv period axis
arjuv  = [apR, cjuv (apR)];  % continuous reprod
ardjuv = [apR, djuv (apR)]; % discrete repod

%% gset output "juv.ps"

plot(apR, cont, '-r', apR, disc, '-g')
title('Effect of juvenile period and discreteness of individuals')
legend('continuous reproduction', 'discrete reproduction', 1)
xlabel('scaled juvenile period')
ylabel('scaled spec pop growth rate')
