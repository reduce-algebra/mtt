PROCEDURE mtt_numpar_update(VAR new_numpar : ParameterVector;
				   old_numpar : ParameterVector);
VAR i : INTEGER;
   
BEGIN {mtt_numpar_update}

   for i:=1 TO MTT_Npar DO {copy values}
      new_numpar[i] := old_numpar[i];
   
   WHILE NOT eof(numparfile) DO {read and update values}
      IF NOT (numparfile^ = chr("#")) THEN
      BEGIN
	 read(numparfile,i); read(numparfile,new_numpar[i]);
      END
      ELSE
	 readln(numparfile);
   
END {mtt_numpar_update};

PROCEDURE mtt_state_update(VAR new_state : StateVector;
			       old_state : StateVector);

VAR i : INTEGER;
   
BEGIN {mtt_state_update}

   for i:=1 TO MTT_Nx DO {copy values}
      new_state[i] := old_state[i];

   WHILE NOT eof(statefile) DO {read and update values}
      IF NOT (statefile^ = chr("#")) THEN
      BEGIN
	 read(statefile,i); read(statefile,new_state[i]);
      END
      ELSE
	 readln(statefile);
      
END {mtt_state_update};

PROCEDURE mtt_simpar_update(VAR dt : REAL);
BEGIN {mtt_simpar_update}

   WHILE NOT eof(simparfile) DO {read and update values}
   BEGIN
      IF NOT (simparfile^ = chr("#")) THEN
	 read(simparfile,dt);
      readln(simparfile); 
   END
END {mtt_simpar_update};
