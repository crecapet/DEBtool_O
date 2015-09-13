function jA = feed (jX,p)
  %% jA = feed (jX,p)
  %% created 2002/06/02 by Bas Kooijman
  %% calculates feeding from arrival flux
  %% jX: arrival rates of substrate
  %% p: parameter vector
  %% jA: assimilated substrate flux

  %% unpack parameters for easy reference
  ks = p(1); %% specific decay rate of satiation
  ts = p(2); %% threshold for satiation
  ds = p(3); %% jump in satiation 

  
  njX = length(jX); jA = zeros(njX,1); % initiate output

  for j = 1:njX % loop across arrival rates
    T = 0; % initiate time
    s = efeed(jX(j),p)/ks; % initiate satiation at time = 0

    for i = 1:10000 % loop across arrival events
      t = -log(rand(1))/ jX(j); % time interval till next arrival event
      T = T + t; % set total time
      s = s * exp(- ks * t); % satiation at next arrival event
      %(s<ts)
      if s < ts % feeding mode
	jA(j) = jA(j) + ds; % add to consumed amount
	s = s + ds; % increase satiation
      end 

    end
    jA(j) = jA(j)/ T; % transform cum amount into rate
 
  end
