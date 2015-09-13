%% fig:sher
%% out:sher

%% Sherwood number as function of substrate concentration and depth of mantle

%% gset output 'sher.ps'

xlabel('scaled conc, X/K')
ylabel('scaled mantle depth')
zlabel('Sherwood number')

x = linspace(1e-2,3.5,20)';
l = linspace(1e-2,5,20)';
sh = sherwood(1, x, l)';
mesh(x,l,sh);
