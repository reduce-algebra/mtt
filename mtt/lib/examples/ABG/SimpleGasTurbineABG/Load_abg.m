function [Load] =  Load_abg
# This function is the acausal bond graph representation of Load
# Generated by MTT on Thu Mar 16 10:34:27 2000
# The file is in Octave format

# Subsystems and Ports

# Port in
  Load.ports.in.type = "SS";
  Load.ports.in.cr = "SS";
  Load.ports.in.arg = "external,external";
  Load.ports.in.repetitions = 1;
  Load.ports.in.status = -1;
  Load.ports.in.connections = [-1 ];

# Port out
  Load.ports.out.type = "SS";
  Load.ports.out.cr = "SS";
  Load.ports.out.arg = "external,external";
  Load.ports.out.repetitions = 1;
  Load.ports.out.status = -1;
  Load.ports.out.connections = [3 ];

# Component PowerSensor
  Load.subsystems.PowerSensor.type = "PS";
  Load.subsystems.PowerSensor.cr = "";
  Load.subsystems.PowerSensor.arg = "";
  Load.subsystems.PowerSensor.repetitions = 1;
  Load.subsystems.PowerSensor.status = -1;
  Load.subsystems.PowerSensor.connections = [1 -2 -3 ];

# Component r_l
  Load.subsystems.r_l.type = "R";
  Load.subsystems.r_l.cr = "lin";
  Load.subsystems.r_l.arg = "flow,r_l";
  Load.subsystems.r_l.repetitions = 1;
  Load.subsystems.r_l.status = -1;
  Load.subsystems.r_l.connections = [2 ];

# Ordered list of Port names
  Load.portlist(1,:) = "in ";
  Load.portlist(2,:) = "out";

# Ordered list of subsystem names
  Load.subsystemlist(1,:) = "PowerSensor";
  Load.subsystemlist(2,:) = "r_l        ";

# Bonds 
  Load.bonds = [
      0 0 
      0 0 
      0 0 
      ];

# Aliases 
# A double underscore __ represents a comma 
Load.alias.out = "out";
Load.alias.r_l = "$2";
Load.alias.in = "in";
Load.alias.PowerSensor = "$1";
