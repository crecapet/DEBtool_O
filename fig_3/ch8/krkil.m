%% out:krkil
%% log P_ow - killing rates for benzenes, alifatic compounds and phenols

Pebenz = [ ...
1.84006366e+000	2.60892194e+000;
2.85320597e+000	4.44882533e+000;
3.59150336e+000	5.81056800e+000;
3.62737253e+000	6.83220607e+000;
4.88557000e+000	2.97982155e+000;
4.78558325e+000	2.98168006e+000;
4.56468711e+000	2.05641757e+000;
3.90829685e+000	2.16155623e+000;
3.38417584e+000	2.78468094e+000;
3.81476072e+000	1.06664128e+000;
3.64295820e+000	1.01407349e+000;
3.35515676e+000	7.22024747e-001;
3.15518327e+000	7.25741773e-001;
3.17092748e+000	9.29907860e-001;
2.78579549e+000	1.01141690e+000;
2.65166532e+000	2.33240770e-001;
2.67731285e+000	-1.76156602e-001;
2.10914633e+000	2.80500073e-001;
2.11034107e+000	4.47764595e-001;
2.01739001e+000	1.43462353e+000;
3.10680990e+000	1.95340444e+000;
2.68174640e+000	2.44457795e+000;
3.19410564e+000	2.17483133e+000;
2.67670195e+000	1.73835120e+000];

Pealifat =[ ...
2.08554289e+000	2.97610613e+000;
2.38287519e+000	8.60254958e+000;
2.59277779e+000	3.98898264e+000;
2.47492284e+000	3.48931468e+000;
2.37082088e+000	2.91504072e+000;
1.99293721e+000	2.01128383e+000;
1.99200796e+000	1.88118956e+000;
2.88503860e+000	2.90548265e+000;
2.85487885e+000	2.68299534e+000;
3.79076025e+000	3.70649194e+000;
3.90343679e+000	3.48134964e+000;
4.36803234e+000	2.52475791e+000;
4.87800332e+000	1.92048222e+000;
2.52895274e+000	1.05336617e+000;
1.95414758e+000	5.80779403e-001;
1.46743585e+000	4.41125475e-001;
1.24301081e+000	1.02150755e+000;
2.69470290e+000	2.25846280e+000;
2.62169117e+000	2.03677200e+000;
2.47871969e+000	2.02084190e+000];

Pephenol =[ ...
1.46305515e+000	-1.72175656e-001;
1.33649287e+000	1.08989107e-001;
1.46584287e+000	2.18107171e-001;
1.95149260e+000	2.09080112e-001;
1.96936082e+000	7.10608174e-001;
1.45554133e+000	7.75920024e-001;
1.97175030e+000	1.04513722e+000;
2.17185653e+000	1.06000373e+000;
2.36046648e+000	1.46541857e+000;
2.49180894e+000	1.85331187e+000;
2.62840849e+000	9.77167163e-001;
2.37236102e+000	1.13062720e+000;
3.18945944e+000	1.52435995e+000;
3.07133900e+000	9.87523331e-001;
3.67404719e+000	1.36665508e+000;
3.67338345e+000	1.27373105e+000;
4.41521219e+000	1.12983070e+000;
4.45625854e+000	2.87627746e+000;
3.18048538e+000	2.26802086e+000;
3.10800464e+000	2.12066897e+000;
5.05949773e+000	3.32974970e+000;
5.04587870e+000	3.42293921e+000;
4.79168970e+000	3.83658621e+000;
5.03929290e+000	4.50112919e+000;
5.96442288e+000	4.01924825e+000;
6.19150413e+000	3.81056703e+000;
3.89672068e+000	4.54095286e+000;
3.07749828e+000	3.84986131e+000;
2.84670129e+000	3.53816540e+000;
3.03199254e+000	3.47896010e+000;
2.71575708e+000	3.20602747e+000];

nrregr_options('default');

pben = nrregr('linear',[1 1; 1 0],Pebenz);
palif =  nrregr('linear',[1 1; 1 0],Pealifat);
pphenol =  nrregr('linear',[1 1; 1 0],Pephenol);
		
P = [1;7];
EPben = [P, linear(pben(:,1),P)];
EPalif = [P, linear(palif(:,1),P)];
EPphenol = [P, linear(pphenol(:,1),P)];

%% gset term postscript color solid 'Times-Roman' 3%
%% gset output 'krkil.ps'

xlabel('log Kow');
ylabel('log killing rate');
%gset nokey
%gset xtics 1
%gset ytics 2
plot(Pebenz(:,1), Pebenz(:,2), 'og', ...
    Pealifat(:,1), Pealifat(:,2), 'ob', ...
    Pephenol(:,1), Pephenol(:,2), 'om', ...
    EPben(:,1), EPben(:,2), 'g', ...
    EPalif(:,1), EPalif(:,2), 'b', ...
    EPphenol(:,1), EPphenol(:,2), 'm') 













