%% Code            Klokdata					
%% Experiment      Body growth					
%% Model           Maintenance					
%% Compound        CuCl					
%% Species         L. rubellus					
%% Time            day					
%% Concentration   millogram/kilogram					
%% Response        milligram					
%% Experimentalist C Klok					
%% Date            18 Januari 1996					
%% Data					
t = [28	56	84	112	154	196]';
c = [13	60	145	362]/1000';		
L =[4.85588615	4.68147225	4.08964271	2.57631347;
7.43077034	7.30614357	6.26752415	5.15262693;
8.9545029	8.69072866	7.65115536	6.26752415;
10.3039982	9.97158601	8.93992917	7.34712739;
10.9875893	10.7167351	9.58392855	7.81284318;
    10.9116896	10.5657253	9.38797315	8.24600357];

p = [.00445 1.193 100 11.66 .018 1e-9 1; 1 1 0 1 0 0 0]';

p = nmregr2('asgrowth',p,t,c,L);
%% p = nrregr2("asgrowth",p,t,c,L);
[cov, cor, sd] = pregr2('asgrowth',p,t,c,L);

[p, sd]

shregr2('asgrowth',p,t,c,L);


