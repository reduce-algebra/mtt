###################################### 
##### Model Transformation Tools #####
######################################

# gawk script: rep_txt2tex
# Converts the text file describing a report to a report.
# P.J.Gawthrop August 1996
# Copyright (c) P.J.Gawthrop, 1996.

###############################################################
## Version control history
###############################################################
## $Id$
## $Log$
## Revision 1.4  1997/05/22 07:36:35  peterg
## \ref --> \Ref
##
## Revision 1.3  1997/05/19 16:43:34  peterg
## Explicit include of tex files 'cos latex2html prefers this!
##
# Revision 1.2  1997/05/19  16:11:10  peterg
# Modified section headers.
#
# Revision 1.1  1996/08/18  19:58:49  peter
# Initial revision
#
###############################################################


BEGIN {
  split(ARGV[1],a,"_");
  system_name = a[1];
  args = ARGV[2];
  comment="\%";
}
{
  if ((match($1,comment)==0)&&(NF==2)) {
    Representation = $1;
    Language = $2;
    Rep_lang = sprintf("%s_%s", Representation, Language);
    section_head = sprintf("System \\textbf{%s}: representation \\textbf{%s}, language \\textbf{%s}", \
			   system_name,Representation,Language);
# section headings
    print "\\section{" section_head "}";
    print "\\label{" Rep_lang "}";
    print "\\index{\\textbf{" system_name "} -- " Representation "}";

# tex files
    if( match("tex",Language)>0) {
      # printf("  \\input{%s_%s.%s}\n", system_name, Representation, Language);
      command = sprintf("cat %s_%s.%s", system_name, Representation, Language);
      system(command);    }
# text files
    if( match("txt r m c h",Language)>0) {
      print "  \\begin{verbatim}";
      command = sprintf("cat %s_%s.%s", system_name, Representation, Language);
      system(command);
      print "  \\end{verbatim}";  
    }
# ps files
    if( match("ps",Language)>0) {
      printf("This representation is given as Figure \\Ref{fig:%s}.\n", Rep_lang);
      print "  \\begin{figure}";
      printf("    \\epsfig{file=%s_%s.%s,width=\\linewidth}\n", \
	     system_name, Representation, Language);
      printf("    \\caption{System \\textbf{%s}, representation %s}\n", system_name, Representation);
      printf("    \\label{fig:%s_%s}\n", system_name, Representation);
      print "  \\end{figure}";
    }
  }
}
END {

}



