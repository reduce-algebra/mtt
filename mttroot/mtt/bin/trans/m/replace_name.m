function string_array = replace_name(string_array, new, index); 
% Replaces a row of a string vector with a string of arbitary length.

###############################################################
## Version control history
###############################################################
## $Id$
## $Log$
## Revision 1.1  1998/07/02 12:36:39  peterg
## Initial revision
##
###############################################################

string_array,new,index
  [N,M]=size(string_array);
  L = length(new);
  
  if index>N 
    error(["String array has less than ", num2str(index), " rows"]);
  end;
  
  if L<M			# Pad the new string
    new = [new, blanks(M-L)];
  elseif M<L			# Pad the array
    for i=1:L-M
      string_array=[string_array, blanks(N)'];
    end
  end

  string_array(index,:) = new;	# Replace ith row by new string

endfunction

    
    


