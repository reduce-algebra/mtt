function [eqn,insigs,innames] = junction_seqn (jun_type,Name, outsig, \
					       insigs, innames)
  ## usage:  [eqn,insigs] = junction_seqn (jun_type,Name, outport, outsig, \
  ##				       insigs)
  ##
  ## 
  ## Junctions

  ## Sanity check
  N = mtt_check_sigs (outsig,insigs);

  outport = outsig(3);

  ## Setup up causality corresponding to junction
  if jun_type=="0"
    i_jun_type = 1;
  elseif jun_type=="1"
    i_jun_type = -1;
  else
    error("Junction type %s unknown", jun_type)
  endif

  ## Is output same causality as junction?
  same_type = outsig(2)==i_jun_type;


  ## LHS 
  eqn = sprintf("%s(%i,%i) :=", Name, abs(outsig(1)), cause2index(outsig(2)));

  ## Find the input bond of the same causality as junction
  one = ones(N,1);
  inport = find(insigs(:,2)==i_jun_type*one);

  ##RHS
  if same_type
    insig = insigs(inport,:);
    inname = innames(inport,:);
    eqn = sprintf("%s\n\t%s(%i,%i)", eqn, Name, abs(insigs(inport,1)),cause2index(i_jun_type));
  else
    insig=[];
    inname="";
    inports = [];
    out_dir = sign(insigs(inport,1));
    for i=1:N
      if i!=inport
	in_dir = sign(insigs(i,1));
	plusminus = sign2name(-in_dir*out_dir);
	eqn = sprintf("%s\n\t%s%s(%i,%i)", eqn, plusminus, Name, \
		      abs(insigs(i,1)), cause2index(-i_jun_type));
	insig = [insig; insigs(i,:)];
	inname = [inname; innames(i,:)];
      endif
    endfor
  endif
  eqn = sprintf("%s;", eqn);
  insigs = insig;
  innames = inname;
endfunction