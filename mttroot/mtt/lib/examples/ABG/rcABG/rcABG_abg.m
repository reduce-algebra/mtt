function [rc] =  rc_abg
# This function is the acausal bond graph representation of rc
# Generated by MTT on Thu Mar 16 08:45:29 2000
# The file is in Octave format

# Subsystems and Ports

# Component c
  rc.subsystems.c.type = "C";
  rc.subsystems.c.cr = "lin";
  rc.subsystems.c.arg = "effort,c";
  rc.subsystems.c.repetitions = 1;
  rc.subsystems.c.status = -1;
  rc.subsystems.c.connections = [5 ];

# Component r
  rc.subsystems.r.type = "R";
  rc.subsystems.r.cr = "lin";
  rc.subsystems.r.arg = "flow,r";
  rc.subsystems.r.repetitions = 1;
  rc.subsystems.r.status = -1;
  rc.subsystems.r.connections = [4 ];

# Component e1
  rc.subsystems.e1.type = "SS";
  rc.subsystems.e1.cr = "SS";
  rc.subsystems.e1.arg = "external,internal";
  rc.subsystems.e1.repetitions = 1;
  rc.subsystems.e1.status = -1;
  rc.subsystems.e1.connections = [-1 ];

# Component e2
  rc.subsystems.e2.type = "SS";
  rc.subsystems.e2.cr = "SS";
  rc.subsystems.e2.arg = "external,0";
  rc.subsystems.e2.repetitions = 1;
  rc.subsystems.e2.status = -1;
  rc.subsystems.e2.connections = [3 ];

# Component mtt1
  rc.subsystems.mtt1.type = "1";
  rc.subsystems.mtt1.cr = "";
  rc.subsystems.mtt1.arg = "";
  rc.subsystems.mtt1.repetitions = 1;
  rc.subsystems.mtt1.status = -1;
  rc.subsystems.mtt1.connections = [1 -2 -4 ];

# Component mtt2
  rc.subsystems.mtt2.type = "0";
  rc.subsystems.mtt2.cr = "";
  rc.subsystems.mtt2.arg = "";
  rc.subsystems.mtt2.repetitions = 1;
  rc.subsystems.mtt2.status = -1;
  rc.subsystems.mtt2.connections = [2 -3 -5 ];

# Ordered list of subsystem names
  rc.subsystemlist(1,:) = "c   ";
  rc.subsystemlist(2,:) = "r   ";
  rc.subsystemlist(3,:) = "e1  ";
  rc.subsystemlist(4,:) = "e2  ";
  rc.subsystemlist(5,:) = "mtt1";
  rc.subsystemlist(6,:) = "mtt2";

# Bonds 
  rc.bonds = [
      1 1 
      0 0 
      1 1 
      0 0 
      0 0 
      ];

# Aliases 
# A double underscore __ represents a comma 
rc.alias.r = "$2";
rc.alias.c = "$1";
