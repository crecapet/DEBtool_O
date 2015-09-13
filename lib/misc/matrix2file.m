function matrix2file(file_nm, matrix_nm, matrix)

  [r c] = size(matrix);
  n = sum(0 == mod(matrix(:),1));
  if n == r * c
    form = ' %d'; % integer
  else
    form = ' %f'; % fixed decimal
  end
  
  oid = fopen([file_nm, '.m'], 'a'); % open file for appending
  txt = [matrix_nm, ' = [\\\n'];
  fprintf(oid, '%s', txt);
  [r,c] = size(matrix);
  for i = 1:r-1
    fprintf(oid, form, matrix(i,:));
    fprintf(oid, '%s', ';\n');
  end
  fprintf(oid, form, matrix(r,:));
  fprintf(oid, '%s', '];\n\n');
  fclose(oid);
