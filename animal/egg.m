function [aEV e0] = egg(par, abE0)
  %% [aEV e0] = egg(par,abE0)
  %% created 2005/09/20 by Bas Kooijman 
  %% par: 8-vector with parameters
  %% abE0: 1 or 2-vector with initial estimates for a_b, E_0
  %%  if length == 1, the first parameter means E_0
  %%  if length == 2, the first parameter means f and E_b = f [E_m] V_b
  %% aEV : 3-vector with age, reserve, structure at birth
  %%       a_b, E_b, V_b
  %% e0: scaler with E_0 (== par(1) if length second input == 1)

  global f E0 EJb EG Em pM pJ pAm kap

  %% unpack parameters
  %% meaning of first parameter depend on length of abE0
  E0  = par(1); % e, E_0, reserve at a = 0
  f   = par(1); % -, scaled functional response and with [E_b] = f [E_m]
  EJb = par(2); % e, E_{Jb}, threshold for birth
  EG  = par(3); % e/L^3, [E_G], spec costs for structure
  Em  = par(4); % e/L^3, [E_m], max spec res density
  pM  = par(5); % e/t.L^3, [p_M] spec som maint costs
  pJ  = par(6); % e/t.L^3, [p_J] spec mat maint costs
  pAm = par(7); % e/t.L^2, {p_{Am}} spec max assim power
  kap = par(8); % -, \kappa, fraction of p_C allocated som maint + growth
  
  if length(abE0) == 1 % par(1) has interpretation E0
    [ab info] = fsolve('fnegg', abE0);
    EV = lsode('degg', [E0; 1e-8; 0], [0; ab]);
    aEV = [ab; EV(2,1:2)'];
    e0 = E0;
  elseif length(abE0) == 2 % par(1) has interpretation f, with [E_b] = f [E_m]
    [abE0 info] = fsolve('fnegg1', abE0);
    ab = abE0(1); E0 = abE0(2);
    EV = lsode('degg', [E0; 1e-8; 0], [0; ab]);
    aEV = [ab; EV(2,1:2)'];
    e0 = E0;
  else
    fprintf('length of initial estimate is not 1 or 2 \n');
    aEV = []; e0 = [];
    return
  end
  
  if info ~= 1
    fprintf('Warning: no convergence; check parameter values \n');
    aEV = []; e0 = [];
  end


  
  