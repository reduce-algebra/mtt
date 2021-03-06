function [Density] =  Density_abg
# This function is the acausal bond graph representation of Density
# Generated by MTT on Thu Mar 16 10:36:39 2000
# The file is in Octave format

# Subsystems and Ports

# Port Pressure
  Density.ports.Pressure.type = "SS";
  Density.ports.Pressure.cr = "SS";
  Density.ports.Pressure.arg = "external,external";
  Density.ports.Pressure.repetitions = 1;
  Density.ports.Pressure.status = -1;
  Density.ports.Pressure.connections = [-4 ];

# Port Temperature
  Density.ports.Temperature.type = "SS";
  Density.ports.Temperature.cr = "SS";
  Density.ports.Temperature.arg = "external,external";
  Density.ports.Temperature.repetitions = 1;
  Density.ports.Temperature.status = -1;
  Density.ports.Temperature.connections = [-5 ];

# Port Density
  Density.ports.Density.type = "SS";
  Density.ports.Density.cr = "SS";
  Density.ports.Density.arg = "external,external";
  Density.ports.Density.repetitions = 1;
  Density.ports.Density.status = -1;
  Density.ports.Density.connections = [3 ];

# Component r
  Density.subsystems.r.type = "R";
  Density.subsystems.r.cr = "Density";
  Density.subsystems.r.arg = "density,ideal_gas,r";
  Density.subsystems.r.repetitions = 1;
  Density.subsystems.r.status = -1;
  Density.subsystems.r.connections = [1 2 -3 ];

# Component mtt1
  Density.subsystems.mtt1.type = "AE";
  Density.subsystems.mtt1.cr = "";
  Density.subsystems.mtt1.arg = "";
  Density.subsystems.mtt1.repetitions = 1;
  Density.subsystems.mtt1.status = -1;
  Density.subsystems.mtt1.connections = [4 -1 ];

# Component mtt2
  Density.subsystems.mtt2.type = "AE";
  Density.subsystems.mtt2.cr = "";
  Density.subsystems.mtt2.arg = "";
  Density.subsystems.mtt2.repetitions = 1;
  Density.subsystems.mtt2.status = -1;
  Density.subsystems.mtt2.connections = [5 -2 ];

# Ordered list of Port names
  Density.portlist(1,:) = "Pressure   ";
  Density.portlist(2,:) = "Temperature";
  Density.portlist(3,:) = "Density    ";

# Ordered list of subsystem names
  Density.subsystemlist(1,:) = "r   ";
  Density.subsystemlist(2,:) = "mtt1";
  Density.subsystemlist(3,:) = "mtt2";

# Bonds 
  Density.bonds = [
      1 1 
      1 1 
      1 1 
      0 0 
      0 0 
      ];

# Aliases 
# A double underscore __ represents a comma 
Density.alias.P = "Pressure";
Density.alias.out = "Density";
Density.alias.rho = "Density";
Density.alias.T = "Temperature";
Density.alias.density__ideal_gas__r = "$1";
