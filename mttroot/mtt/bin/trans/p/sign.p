FUNCTION sign(x	: REAL) : REAL;
{ This useful function is missing from Pascal }

BEGIN
   IF X>=0 THEN
      sign := 1
   ELSE
      sign := -1;
END; { sign }

