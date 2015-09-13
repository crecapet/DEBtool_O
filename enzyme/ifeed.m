function jA = ifeed (p,jX)
  %% jA = ifeed (p,jX)
  %% created 2002/06/04 by Bas Kooijman
  %% calculates expected feeding from arrival flux
  %% jX: arrival rates of substrate
  %% p: parameter vector
  %% jA: assimilated substrate flux

  %% unpack parameters for easy reference
  m = p(1); %% specific decay rate of satiation
  la2 = p(2); %% threshold for satiation
  K = p(3);
  jX = jX(:,1)/K; %% arrival rates

  %% m = ks/ log(1 + ds/ ts); la2 = 2 - ds/ ts;  
  jA = (jX + m - sqrt((jX + m).^2 - 2 * la2 * m * jX))/ la2;

