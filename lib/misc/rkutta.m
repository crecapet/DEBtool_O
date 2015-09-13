function  xt = rkutta (fn, x0, tmax, dt)
  %% xt = rkutta (fn, x0, tmax, dt)
  %% Created: 18 aug 2000 by Bas Kooijman
  %% Method: Press et al 1992 Numerical Recipes in C, Cambridge UP, p 716
  %% Runge Kutta 5 integration of a set of ode's specified by 'fn'
  %%   fn: string, for user-defined function of structure dx = fn (x, t)
  %%       dx, x are column vectors of equal lengths, t is a scalar
  %%   x0: column vector, value of vector x at t=0
  %%   tmax: scalar, max value of t, starting from t = 0
  %%   dt: scalar, fixed step size; If not specified: step size control 
  %%   xt: matrix with times and x(t) values starting with t=0 and x0
  %% Requires: user-defined function 'fn' 

  imax = 10000; accuracy = 1e-10; [nx n1] = size(x0); 
  t = 0; i = 1; x = x0; 
  a = [1;0.2;0.3;0.6;1;7/8];
  b2 = 0.2; b3 = [3;9]/40; b4 = [0.3;-0.9;1.2]; b5 = [-11;135;-140;70]/54;
  b6 = [1631;175;575;44275;253]./[55296;512;13824;110592;4096];
  c = [37;0;250;125;0;512]./[378;1;621;594;1;1771];
  d = c - [2825;0;18575;13525;277;1]./[27648;1;48384;55296;14336;4];

  str = ['k1 = dt*', fn, '(x, t); ', ...
         'k2 = dt*', fn, '(x + k1*b2, t + dt*a(2)); ', ...
         'k3 = dt*', fn, '(x + [k1 k2]*b3, t + dt*a(3)); ', ... 
	 'k4 = dt*', fn, '(x + [k1 k2 k3]*b4, t + dt*a(4));', ...
	 'k5 = dt*', fn, '(x + [k1 k2 k3 k4]*b5, t + dt*a(5));', ...	 
	 'k6 = dt*', fn, '(x + [k1 k2 k3 k4 k5]*b6, t + dt*a(6));' ...
	 ];

  if exist('dt', 'var') == 1                   % fixed step size
    xt = zeros(tmax/dt, 1 + nx);
    xt(1,:) = [t x'];
    while t <= tmax
      eval(str);
      x = x + [k1 k2 k3 k4 k5 k6]*c;
      t = t + dt; i = i + 1;
      xt(i,:) = [t x'];
    end

  else                                  % adaptive step size
    xt(1,:) = [t x']; dt = 0.01;
    while t <= tmax && i <= imax
      eval(str);
      error = max(abs([k1 k2 k3 k4 k5 k6]*d));
      if error >= accuracy
	dt = 0.9*dt*(accuracy/error)^0.25;
      else
	dt = 0.9*dt*(accuracy/error)^0.2;
        x = x + [k1 k2 k3 k4 k5 k6]*c;
        t = t + dt; i = i + 1;
        xt(i,:) = [t x'];
      end
    end
    if i >= imax
      fprintf(['Warning: no convergence with ', num2str(imax), ' steps \n']);
    end
    
  end
