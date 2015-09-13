ll = survi_chi(1,.05);
global ll n xg;
  n=5; xg=1;

function f = expb(l) 
  global ll n xg;
  f=2*n*(l*xg-1-log(l*xg))- 1.1*ll;
endfunction

l0 = fsolve("expb",0.1);
l1 = fsolve("expb",10);

l= linspace(l0,l1,100);
lik = 2*n*(l*xg-1-log(l*xg));

L0 = (1-sqrt(1.1*ll/n))/xg;
L1 = (1+sqrt(1.1*ll/n))/xg; 
L= linspace(L0,L1,100);
LIK = n*(L*xg-1).^2;

gset clf
%% gset term postscript color solid "Times-Roman" 40
%% gset output "expolik.ps"
%gset xrange [0:2.5]
%gset xtics 0, .5, 2.5
%gset yrange [0:4.5]
%gset ytics 0, 1, 4.5

plot(l, lik, 'g', L, LIK, 'r', [min(l0,L0);max(l1,L1)], [ll;ll], 'k');
pause(2);


%% parameter of exponential distribution equals 1
clear; clg; hold on;
gset xrange [0:2];

global X;
n=2; m=1000; X = n./sum(-log(rand(n,m)); xs = surv(X);
%% plot(xs(:, 1), xs(:,2), "g");
%% x=(.1:.1:10)'; l=2*n*(x - 1 - log(x)); s = lik2surv(l, 1);
%% plot(x, s, "r");


function f = expa(l) 
  global ll n;
  f=2*n*(l*-1-log(l)) - ll;
endfunction

function i=findint(x,j)
  i(1) = fsolve('expa',j(1));
  i(2) = fsolve('expa',j(2));
endfunction

function xy = comp
  global ll X n;
  int = [.9 1.1]; xy=zeros(99,2);
			
  for ll=.01:.01:.99
    int = findint(ll,int);
    p = frac(X, int); 
    xy(i,:) = [ll, 1 - p(1) + p(2);]
  end 
endfunction

xy=comp;
plot(xy(:,1),xy(:,2),"m");
