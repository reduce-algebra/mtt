function [y,u,t,par_names,Q,extras] = idRC_ident_numpar;

  ## usage: [y,u,t,par_names,Q,extras] = idRC_ident_numpar;
  ## Edit for your own requirements
  ## Created by MTT on 

    
  ## This section sets up the data source
  ## simulate = 0  Real data (you supply idRC_ident_data.dat)
  ## simulate = 1  Real data input, simulated output
  ## simulate = 2  Unit step input, simulated output
  simulate = 0;
  

  ## System info
  [n_x,n_y,n_u,n_z,n_yz] = idRC_def;
  simpars = sidRC_simpar;

  ## Access or create data
  if (simulate<2)		# Get the real data
    if (exist("idRC_ident_data.dat")==2)
      printf("Loading idRC_ident_data.dat\n");
      load idRC_ident_data.dat
    else
      printf("Please create a loadable file idRC_ident_data.dat containing y,u and t\n");
      return
    endif
  else 
    switch simulate
      case 2			# Step simulation
	t = [0:simpars.dt:simpars.last]';
	u = ones(size(t));
      otherwise
	error(sprintf("simulate = %i not implemented", simulate));
    endswitch
  endif
  
  if (simulate>0)
    par = idRC_numpar();
    x_0 = idRC_state(par);
    dt = t(2)-t(1);
    simpars.dt = dt;
    simpars.last = t(length(t));
    y =  idRC_sim(zeros(n_x,1), par, simpars, u);
  endif

  ## Default parameter names - Put in your own here
  sympar = idRC_sympar;	# Symbolic params as structure
  par_names = struct_elements (sympar);	# Symbolic params as strings
  [n,m] = size(par_names);	# Size the string list

  ## Sort by index
  for [i,name] = sympar
    par_names(i,:) = sprintf("%s%s",name, blanks(m-length(name)));
  endfor
  
  par_names = "r";		# Estimate r only

  ## Output weighting vector
  Q = ones(n_y,1);
  
  ## Extra parameters
  extras.criterion = 1e-5;
  extras.emulate_timing = 0;
  extras.max_iterations = 10;
  extras.simulate = simulate;
  extras.v =  1e-2;
  extras.verbose = 1;
  extras.visual = 1;

endfunction
