function go_out = ginsh (go_in)

  ## usage:  go_out = ginsh (go_in)
  ##         go_out, go_in strings containing valid ginsh code
  ## Interface to ginsh to provide symbolic manipulation within octave
  ## Part of the gino (ginsh-octave) toolbox

  ## Copyright (C) 2002 by Peter J. Gawthrop

  ##   This program is free software; you can redistribute it and/or modify
  ##    it under the terms of the GNU General Public License as published by
  ##    the Free Software Foundation; either version 2 of the License, or
  ##    (at your option) any later version.
  
  ##    This program is distributed in the hope that it will be useful,
  ##    but WITHOUT ANY WARRANTY; without even the implied warranty of
  ##    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  ##    GNU General Public License for more details.
  
  ##    You should have received a copy of the GNU General Public License
  ##    along with this program; if not, write to the Free Software
  ##    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 
  command = sprintf("echo '%s;' | ginsh ", go_in); # sh command
  go_out = system(command);	# execute it
  
  if (length(go_out)>0)		# Strip trailing NL
    go_out = substr(go_out,1,length(go_out)-1);
  endif
endfunction