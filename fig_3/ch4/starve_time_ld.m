function t = starve_time_ld(p, lt) % see {230}
  t = (lt(:,1)/ p(1)) .* log(p(2) ./lt(:,1));
