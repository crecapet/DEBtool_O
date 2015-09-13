%% simulation of standard DEB model with stochastic searching
%  using scaling to dimensionless quantities
%  handling and searching intervals only evaluate length at start interval
%  for theory, see comments to DEB3 for 2.9
%  created by Bas kooijman at 2010/04/01, modified 2011/03/07

global vHb vHp g kapR1 kapG lT k k1 ha sG sH uE0 f
global vH_max 

% control parameters
x = .75; % food density; for x = 1 mean food intake is 0.5 * max
z = 5; % zoom factor: Lm = 1 cm for z = 1
MX = 5e-4 * z^3; % mmol, mass of food particle

% physiological parameters
vHb = .0004; % maturity at birth
vHp = .25;   % maturity at puberty
rhoh = 8 * z/ MX; % spec handling rate, MX in mmol: {h_XAm} L_m^2/ k_M
  % {h_XAm} max spec feeding rate in particles/ time/ surface
g = 3/ z;    % energy investment ratio: [E_G]/ (kap [E_m])
kapR1 = .2;  % reproduction efficiency: kap_R (1 - kap)
kapG = .8;   % growth efficiency: mu_V [M_V]/ [E_G]
lT = 0;      % heating length: L_T/ L_m
k = .3;      % maintenance ratio: k_J/ k_M
k1 = .2;     % maturity decay: k_J^prime/ k_M

% survival parameters
delX = .8; % hard survival condition on shrinking
  % death occurs if l < delX * max l (in the past)
sH = 2;    % soft survival condition on rejuvenation
  % h_H = sH (max vH - vH)
ha = z * 3e-5; % Weibull aging acelleration
sG = .001;  % Gompertz stress coeff

% conditions at birth
t = 0; % time
eb = x/(1 + x); % reserve density
[uE0 lb] = get_ue0 ([g; k; vHb], eb); % initial reserve, length at birth
qb = 0; % acceletation; not correct but ...
hb = 0; % hazard; not correct but ...
Sb = 1; % survival prob; not correct but ...
Nb = 0; % cumulative reproduction
vH_max = vHb; % passed to dtraject to detect rejuvenation
tf = []; % initiate times of feeding
% determine handling or searching at birth
th = 1/(rhoh * lb^2); ts = th/ x; % handling & searching periods at birth
f = rand(1) < ts/ (ts + th); % f = 0 (if searching) or 1 (if handling);
vars = [eb, lb, vHb, qb, hb, Sb, Nb]'; % pack initial vars

Vars = [t, f, vars']; % initiate extended vars 
nV = length(Vars);

tmax = 2 * get_tm_s([g; lT; ha; sG], eb); % simulation interval

% actual simulation
while Vars(end,1) < tmax % continue simulation till tmax
  l = Vars(end,4); % current length
  dt = 1/ (rhoh * l^2); % handling interval
  if f == 0
    dt = - dt * log(rand(1))/ x; % searching interval
    tf = [tf; Vars(end,1) + dt]; % append to times of feeding
  end
  nt = 5; t_int = Vars(end,1) + linspace(0,dt,nt)'; % new time interval
  vars0 = Vars(end,3:nV)';   % new vars values
  vars_int = lsode('dtraject', vars0, t_int);
  Vars = [Vars; t_int, [f * ones(nt,1), vars_int]]; % append to existing trajectory
  f = ~f; % alternate f
end

% unpack vars
t = Vars(:,1);
f = Vars(:,2); e = Vars(:,3); l = Vars(:,4); vH = Vars(:,5); 
q = Vars(:,6); h = Vars(:,7); S = Vars(:,8); N = Vars(:,9);

% survival by shrinking, rejuvenation
death = find(l < delX * cummax(l),1,'first'); % length > delX * max length
if isempty(death)
  alive = t>-1; % must be booleans
else
  alive = 1:length(l) < death; % once dead is dead forever
end
h_vH = sH * (cummax(vH) - vH); % hazard due to rejuvenation

%% plotting
% shtraject; return 

close all

figure
subplot(2,3,1)
plot(t(alive), e(alive), 'g', t(~alive), e(~alive), 'r')
ylabel('reserve density')
xlabel('time since birth')

subplot(2,3,2)
hold on
plot(t(alive), l(alive), 'g', t(~alive), l(~alive), 'r')
plot(t(alive), S(alive), '-', 'Color', [0 .75 0])
plot(t(~alive), S(~alive), '-', 'Color', [.75 0 0])
ylabel('length, survival')
xlabel('time since birth')

subplot(2,3,3)
plot(t(alive), vH(alive), 'g', t(~alive), vH(~alive), 'r')
ylabel('maturity')
xlabel('time since birth')

subplot(2,3,4)
plot(t(alive), q(alive), 'g', t(~alive), q(~alive), 'r')
ylabel('acceleration')
xlabel('time since birth')

subplot(2,3,5)
hold on
plot(t(alive), h(alive), 'g', t(~alive), h(~alive), 'r')
plot(t(alive), h_vH(alive), '-', 'Color', [0 .75 0])
plot(t(~alive), h_vH(~alive), '-', 'Color', [.75 0 0])
ylabel('hazard by ageing, rejuv')
xlabel('time since birth')

subplot(2,3,6)
plot(t(alive), N(alive), 'g', t(~alive), N(~alive), 'r', ...
     tf, 1:length(tf), 'k')
ylabel('cum reprod, cum feeding')
xlabel('time since birth')
