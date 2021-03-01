% Reduce file to generate equations
% Copyright (C) 2000 by Peter J. Gawthrop

PROCEDURE latex_equations;
BEGIN
IF MTTNx>0 THEN
BEGIN
  write"\begin{equation}"$
  write"\begin{aligned}"$
  FOR Row := 1:MTTNx DO
  BEGIN
	write "\dot MTTX", Row, " &= "$
	write "{"$
	write MTTdx(Row,1)$
	write "}"$
        IF Row<MTTNx THEN write "\cr"$
  END$
  write"\end{aligned}"$
  write"\end{equation}"$
END$

IF MTTNz>0 THEN
BEGIN
  write"\begin{equation}"$
  write"\begin{aligned}"$
FOR Row := 1:MTTNz DO
  BEGIN
	write "MTTz", Row, " &= "$
	write "{"$
	write MTTz(Row,1)$
	write "}"$
        IF Row<MTTNz THEN write "\cr"$
  END$
  write"\end{aligned}"$
  write"\end{equation}"$

END$

IF MTTNyz>0 THEN
BEGIN
  write"\begin{equation}"$
  write"\begin{aligned}"$
FOR Row := 1:MTTNyz DO
  BEGIN
	write "0 &= "$
	write "{"$
	write MTTyz(Row,1)$
	write "}"$
        IF Row<MTTNyz THEN write "\cr"$
  END$
  write"\end{aligned}"$
  write"\end{equation}"$

END$

IF MTTNy>0 THEN
BEGIN
  write"\begin{equation}"$
  write"\begin{aligned}"$
FOR Row := 1:MTTNy DO
  BEGIN
	write "MTTy", Row, " &= "$
	write "{"$
	write MTTy(Row,1)$
	write "}"$
        IF Row<MTTNy THEN write "\cr"$
  END$
  write"\end{aligned}"$
  write"\end{equation}"$

END$

END$

END$