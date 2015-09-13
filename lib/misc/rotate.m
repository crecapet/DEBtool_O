function rxy = rotate(xy,angle)
  %% rxy = rotate(xy,angle)
  %% coded 2005/10/05 by Bas Kooijman
  %% xy: (n,2) matrix with point coordinates
  %% angle: scaler with angle of rotation
  %% rxy: (n,2) matrix with rotate point coordinates
  
  ca = cos(angle); sa = sin(angle);
  rot = [ca sa; -sa ca];
  rxy = xy * rot';
