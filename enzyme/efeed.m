function jA = efeed (jX,p)
  %% jA = efeed (jX,p)
  %% created 2002/06/04 by Bas Kooijman
  %% calculates expected feeding from arrival flux
  %% jX: arrival rates of substrate
  %% p: parameter vector
  %% jA: assimilated substrate flux

  %% unpack parameters for easy reference
  ks = p(1); %% specific decay rate of satiation
  ts = p(2); %% threshold for satiation
  ds = p(3); %% jump in satiation 

  m = ks/ log(1 + ds/ ts); la2 = 2 - ds/ ts;  
  jA = (jX + m - sqrt((jX + m).^2 - 2 * la2 * m * jX))/ la2;

