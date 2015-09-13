global N c;

t = [0 1]';
c = [1 2 4 8 16 32 64 128]';
N = [1 1 1 1 1 1 1 1; 1 1 0 1 0 1 0 0];

function f = fnlogist(p,t,c)
  f = (c'/ p(1)).^p(2);
  f = [ones(1,length(c)); 1./ (1 + f)];
endfunction

nmsurv2('fnlogist',[14 0.84; 1 1]',t,c,N)

function f = liklogist(l,s)

  global N c;
  
  nl = length(l);
  ns = length(s);
  f = zeros(nl,ns);

  for i=1:nl
    for j=1:ns
      p = 1./ (1 + (c/ l(i)).^s(j));
      f(i,j) = - sum(N(2,:)'.*log(p)) - sum((N(1,:)-N(2,:))'.*log(1-p));
    end
  end

endfunction

lC =.05* [140:500]'; s = .01*(40:130)';
contour(lC,s,liklogist(lC, s),200);


      



