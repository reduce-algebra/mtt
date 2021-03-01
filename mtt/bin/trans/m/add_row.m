function New=add_row(Old,Row); # Adds a row to end of matrix

  [N,M]=size(Old);
  [n,m] = size(Row);

  if m>M
    Old = [Old, zeros(N,m-M)];	# Pad with zeros
  elseif M>m
    Row = [Row, zeros(n,M-m)];
  endif

  New = [Old;Row];

endfunction

	   