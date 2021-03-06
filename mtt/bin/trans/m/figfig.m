function figfig(filename,language,boxed,monochrome,key)
  ## Usage: figfig(filename[,language,boxed,monochrome])
  ## Puts octave figure into fig file (filename.fig)
  ## If second argument, converts to filename.language using fig2dev
  ## eg:
  ##    figfig("foo");
  ##    figfig("foo","eps");
  ##    figfig("foo","pdf");
  ## Boxed=1 gives a box around the figure
  ## Monochrome=1 gives a monchrome plot
  ## key=1 gives the key legend

  ###############################################################
  ## Version control history
  ###############################################################
  ## $Id$
  ## $Log$
  ## Revision 1.11  2004/03/15 11:44:34  gawthrop
  ## Yet another option (to allow legend).
  ##
  ## Revision 1.10  2003/08/19 13:13:28  gawthrop
  ## No legend
  ##
  ## Revision 1.9  2002/09/12 08:39:27  gawthrop
  ## Removed spurious text
  ##
  ## Revision 1.8  2002/09/11 15:04:59  gawthrop
  ## Optional boxing
  ##
  ## Revision 1.7  2002/08/20 15:51:17  gawthrop
  ## Update to work with ident DIY rep
  ##
  ## Revision 1.6  2001/05/24 07:44:36  gawthrop
  ## Minor updates ..
  ##
  ## Revision 1.5  2001/05/10 19:08:35  gawthrop
  ## Cosmetic improvements
  ##
  ## Revision 1.4  2001/05/08 15:18:12  gawthrop
  ## Added trig and hyperbolic functions to argument exclusion list
  ##
  ## Revision 1.3  2001/04/10 12:54:50  gawthrop
  ## Minor fixes for sensitivity versions
  ##
  ## Revision 1.2  2000/12/27 16:06:02  peterg
  ## *** empty log message ***
  ##
  ## Revision 1.1  2000/11/03 10:43:10  peterg
  ## Initial revision
  ###############################################################

  if nargin<3
    boxed=0;
  endif
  
  if nargin<4
    monochrome=0;
  endif
  
  if nargin<5
    key=0;
  endif
  
  
  figfilename = sprintf("%s.fig",filename);
  
  eval(sprintf("gset output \"%s\" ",figfilename));

  if key!=1
    gset nokey			# No legend
  endif
  
  if (monochrome==1)
    gset term fig monochrome portrait fontsize 16 size 20 10 metric thickness 3
  else
    gset term fig color portrait fontsize 16 size 20 10 metric thickness 3
  endif
  replot;
  gset term x11
  gset output
  replot;

  if boxed # Add a box - makes a visible bounding box
    fid = fopen(figfilename,"a+t");
    fprintf(fid,"2 4 0 2 31 7 50 0 -1 0.000 0 0 7 0 0 5\n");
    fprintf(fid,"\t9675 5310 9675 270 225 270 225 5310 9675 5310\n");
    fclose(fid);
  endif
  

  if nargin>1			# Do a file in another langueage
    sleep(1);
    psfilename = sprintf("%s.%s",filename,language);
    convert = sprintf("fig2dev -L%s %s > %s", language, figfilename, psfilename);
    system(convert);
  endif

  gset key			# Put it back
endfunction
