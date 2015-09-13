function U_L = milk(f, p)
% f: scalar with scaled functional response
% 5-vector with parameters
% U_L: scalar with scaled amount of milk per baby, from birth till weaning
%      U_L = E_L/ {p_Am}: U_L = f int_0^(a_x - a_b) L^2(t) dt
%   the amount of (scaled) energy that is required to produce this milk is U_E/ kalp_RL

% unpack parameters
L_b = p(1); L_x = p(2); L_i = p(3); % cm, lengths at birth, weaning, ultimate
t_x = p(4);    % d, time since birth at weaning
kap_L = p(5);  % -, conversion efficiency from milk to (baby) reserve

r_B = log((L_i - L_b)/(L_i - L_x))/ t_x; % 1/d, von Bert growth rate
% int_L2 = \int_0^{t_x} L^2(t) dt, where t_x = a_x - a_b
int_L2 =  L_i^2 * t_x - (L_i + (L_x + L_b)/2) * (L_x - L_b)/ r_B; % d.cm^2
U_L = f * int_L2/ kap_L; % d.cm^2 