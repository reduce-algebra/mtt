function ppp_examples ()

  ## usage:  ppp_examples ()
  ##
  ## Various menu-driven PPP examples


  str="menu(""Predictive Pole-Placement (PPP) examples"",""Exit"",""All examples"; # Menu string

  used = 2;
  option=used;  

  while option>1

    exists=1; 
    i_example=1;		# Example counter
    while exists
      name=sprintf("ppp_ex%i",i_example);
      exists=(exist(name)==2);
      if exists
	title = eval(sprintf("%s(1);", name)); 
	str = sprintf("%s"",""%s",str,title);
	i_example++;
      endif
    endwhile
    n_examples = i_example-1;

    str = sprintf("%s"" );\n",str);

    option=eval(str);		# Menu - ask user

    if option>1			# Do something - else return
      if option==2		# All examples
	Examples=1:n_examples;
      else			# Just the chosen examples
	Examples = option-used;
      endif
      for example=Examples	# Do the chosen examples
	eval(sprintf("Title = ppp_ex%i(1);",example));
	disp(sprintf("Evaluating example ppp_ex%i:\n\t %s\n", example, Title));
	eval(sprintf("ppp_ex%i;",example));
      endfor
    endif
    
    
  endwhile

endfunction






