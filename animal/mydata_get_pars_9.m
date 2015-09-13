% mydata_get_pars_9
% runs get_pars_9 and its inverse iget_pars_9

% set parameters according to generalised animal (see mydata_my_pet, but kap_G = 0.8)
%  assume T = T_ref; f = 1
d_V = 0.1;         % g/cm^3, specific density of structure
z = 1;            %  -, zoom factor
p_Am = z * 18/0.8; % 1 J/d.cm^2, max specific assimilation rate
v = 0.02;          % 2 cm/d, energy conductance
kap = 0.8;         % 3 -, allocation fraction to soma = growth + somatic maintenance
p_M = 20;          % 4 J/d.cm^3, [p_M], vol-specific somatic maintenance
E_G = 2.6151e4 * d_V; % 5 J/cm^3, [E_G], spec cost for structure
E_Hb = z^3 * .275; % 6 J, E_H^b, maturity at birth
E_Hj = 1.0001 * E_Hb; % 7 J, E_H^j, maturity at metamorphosis
E_Hp = z^3 * 50;   % 8 J, E_H^p, maturity at puberty
h_a = 1e-6;        % 9 1/d^2, Weibull aging acceleration

% pack par
par = [p_Am; v; kap; p_M; E_G; E_Hb; E_Hj; E_Hp; h_a];
data = iget_pars_9(par); % map par to data
Epar = get_pars_9(data); % map data to par
Edata = iget_pars_9(Epar);

txt_par = { ...
 '1 p_Am, J/d.cm^2, max specific assimilation rate';
 '2 v, cm/d, energy conductance';
 '3 kap, -, allocation fraction to soma';
 '4 p_M, J/d.cm^3, [p_M], vol-specific somatic maintenance';
 '5 E_G, J/cm^3, [E_G], spec cost for structure';
 '6 E_Hb, J, E_H^b, maturity at birth';
 '7 E_Hj, J, E_H^j, maturity at metamorphosis';
 '8 E_Hp, J, E_H^p, maturity at puberty';
 '9 h_a, 1/d^2, Weibull aging acceleration'};

txt_data = { ...
 '1 d_V, g/cm^3, specific density of structure';
 '2 a_b, d, age at birth';
 '3 a_p, d, age at puberty';
 '4 a_m, d, age at death due to ageing';
 '5 W_b, g, wet weight at birth';
 '6 W_j, g, wet weight at metamorphosis';
 '7 W_p, g, wet weight at puberty';
 '8 W_m, g, maximum wet weight';
 '9 R_m, #/d, maximum reproduction rate'};

printpar(txt_par, par, Epar, 'name, pars, back-estimated pars')
fprintf('\n'); % insert blank line
printpar(txt_data, data, Edata, 'name, data, back-estimated data')

MRE_par = sum(abs(par - Epar) ./ par)/9;
MRE_data = sum(abs(data - Edata) ./ data)/9;
fprintf('\n'); % insert blank line
printpar({'mean relative error of par and data'}, MRE_par, MRE_data, '')
