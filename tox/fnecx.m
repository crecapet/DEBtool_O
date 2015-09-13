function f = fnecx (c,p)
  %% f = fnecx (c,p)
  %% created 2002/06/10 by Bas Kooijman
  %% routine called by ecx
  %% function f = fnecx (c)
  %% c: scalar with concentration
  %% f: function to be set equal to zero for EC(100x) 
 
  global X FNM t;

  eval(['r = ', FNM, '(p,[0;t],[0;c]);']); % get reponse at blank & conc c
  f = ((1-X)*r(2,1) - r(2,2))^2;
      %% response at c equals fraction X of that in blank
