function shbiochem 
  %% the biochem model
  %% Martina Vijver
  %% 2001/12/11, modified 2009/02/20

  global l0 C_Ms0 C_Mp0 C_Ma0 C_Mi0

  par_biochem;

  %% init state variables
  C0 = [l0 C_Ms0 C_Mp0 C_Ma0 C_Mi0]';

  %%  set time points
  t = linspace(0,500,100);
  Ct = lsode('dbiochem', C0, t);

  %% make plots
  clf

  subplot(2,3,1)
   xlabel('time, d'); ylabel('scaled length')
   plot(t,Ct(:,1),'g');

  subplot(2,3,2)
   xlabel('time, d'); ylabel('metal conc in solids, mol/g')
   plot(t,Ct(:,2),'g');

  subplot(2,3,3)
   xlabel('time, d'); ylabel('metal conc in pore water, mol/l')
   plot(t,Ct(:,3),'g');

  subplot(2,3,4)
   xlabel('time, d'); ylabel('active metal conc in pore water, mol/l')
   plot(t,Ct(:,4),'g');

  subplot(2,3,5)
   xlabel('time, d'); ylabel('metal conc in annelid, mol/g')
   plot(t,Ct(:,5),'g');
 