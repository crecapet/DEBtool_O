function shmics
  %% created 2002/04/09 by Bas Kooijman
  %% miscellaneous plots for 'animal'
  %% clg; gset nokey; hold off;

  global T_ref pars_T;
  
  %% multiplot(2,2);
  subplot (2, 2, 1); shtemp2corr (T_ref, pars_T);
  subplot (2, 2, 2); shtime2eweight;
  subplot (2, 2, 3); shlength2reprod;
  subplot (2, 2, 4); shlength2res_time;
  %% multiplot(0,0);