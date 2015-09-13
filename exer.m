aL = [0 1; 1 4; 2 5; 3 5.5]

function L = bert(p,aL)
  L = p(2) - (p(2) - p(1)) * exp(-p(3) * aL(:,1));
endfunction

LOADPATH = "lib//:";

p = nrregr("bert",[1 6 1]',aL)
[cov cor sd] = pregr("bert",p,aL);
[p,sd]

shregr_options("default")
shregr("bert",p,aL)