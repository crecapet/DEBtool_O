%% fig:Rutg90
%% bib:Rutg90,Heij91,HeijDijk91
%% out:Rutg90

%% disspipating heat as function of chemical potential

Rutg90 = [131 90.128;
	  253 176.418;
	  260 155.98;
	  296 163.52;
	  289 180.166;
	  334 149.37;
	  376 194.04;
	  422 230.202;
	  476 237.35;
	  546 269.137;
	  657 391.716];

nrregr_options('report',0);
p = nrregr('linear', [0 0; 1 1],Rutg90);
[cov cor sd] = pregr('linear',p,Rutg90);
printpar('prop constant', p(2,1), sd(2));
mu = [0 660]';
h = linear(p(:,1), mu);
nrregr_options('report',1);


xlabel('chem potential substrate, kJ/C-mol')
ylabel('dissipating heat, kJ/C-mol')
plot(Rutg90(:,1), Rutg90(:,2), '.g', mu, h, '-r')
