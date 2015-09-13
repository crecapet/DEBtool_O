%% show data and model predictions for cnplim
  shregr2_options('plotnr',1);
  shregr2_options('xlabel', 'time, h');
  shregr2_options('zlabel', 'OD');

  subplot(1,3,1)
    select = 1:7; % select only these data-set-numbers for plotting
    shregr2 ('cnplim', p, time, NP(select,:), OD(:,select));
   subplot(1,3,2)
    select = [1, 8:13]; % select only these data-set-numbers for plotting
    shregr2 ('cnplim', p, time, NP(select,:), OD(:,select));
   subplot(1,3,3)
    select = [1, 14:19]; % select only these data-set-numbers for plotting
    shregr2 ('cnplim', p, time, NP(select,:), OD(:,select));
