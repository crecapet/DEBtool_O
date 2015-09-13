jX = (1:15)';
P = [.5 1 .1]';
jA = feed(jX,P);

p = pfeed(jX,jA)

jx = linspace(0,16,100)';
ja = ifeed(p,jx);

plot(jX, jA,'g*',jx,ja,'r');
