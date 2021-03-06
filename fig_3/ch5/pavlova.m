function [MV1, MV2, MV3, MV4, XP1, XP2, XP3, XP4, ...
	  XB1, XB2, XB3, XB4, qP1, qP2, qP3, qP4, ...
	  qB1, qB2, qB3, qB4] = pavlova(p, rMV1, rMV2, rMV3, rMV4, ...
	    rXP1, rXP2, rXP3, rXP4, rXB1, rXB2, rXB3, rXB4,...
	    rqP1, rqP2, rqP3, rqP4, rqB1, rqB2, rqB3, rqB4);  
  %% we assume: rMV(:,1) = rXP(:,1) = rXB(:,1) = rmP(:,1) = rmB(:,1)
  
  global Xr
  
  [MV1 XP1 XB1 qP1 qB1] = fnpavlova(p, rMV1, Xr(1,:));
  [MV2 XP2 XB2 qP2 qB2] = fnpavlova(p, rMV2, Xr(2,:));
  [MV3 XP3 XB3 qP3 qB3] = fnpavlova(p, rMV3, Xr(3,:));
  [MV4 XP4 XB4 qP4 qB4] = fnpavlova(p, rMV4, Xr(4,:));

