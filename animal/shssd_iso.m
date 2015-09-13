function shssd_iso(p)

[f0 info] = f_ris0 (p); % f at which r = 0
if info ~= 1
    fprintf('warning: no convergence for f0\n')
end

f = linspace(f0,1,300)'; n = length(f);
r = zeros(n,1); 
Ea = zeros(n,1); 
EL = zeros(n,1); 
EL2 = zeros(n,1); 
EL3 = zeros(n,1); 

[r(1) Ea(1) EL(1) EL2(1) EL3(1) info] = ssd_iso(p, f0, 0);
for i=2:n
 [r(i) Ea(i) EL(i) EL2(i) EL3(i) info] = ssd_iso(p, f(i), r(i-1));
 if info ~= 1
    fprintf(['warning: no convergence for r = ', num2str(r(i)),' at i = ', num2str(i), '\n'])
 end
end

figure
plot(f,r,'r')
xlabel('scaled functional response f')
ylabel('spec population growth rate')

figure
plot(f,Ea,'r')
xlabel('scaled functional response f')
ylabel('mean age')

figure
plot(f,EL,'r')
xlabel('scaled functional response f')
ylabel('mean length')

figure
plot(f,EL2,'r')
xlabel('scaled functional response f')
ylabel('mean squared length')

figure
plot(f,EL3,'r')
xlabel('scaled functional response f')
ylabel('mean cubed length')