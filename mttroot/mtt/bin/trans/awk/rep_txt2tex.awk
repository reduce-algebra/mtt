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
# Revision 1.1  1996/08/18  19:58:49  peter
# Initial revision
#
###############################################################


BEGIN {
  split(ARGV[1],a,"_");
  system_name = a[1];
  args = ARGV[2];
}
{
  if (NF==2) {

    Representation = $1;
    Language = $2;
    Rep_lang = sprintf("%s_%s", Representation, Language);
    section_head = sprintf("System \\textbf{%s}: representation \\textbf{%s}, language \\textbf{%s}", \
			   system_name,Representation,Language);

# tex files
    if( match("tex",Language)>0) {
      print "\\section{" section_head "}";
      printf("  \\input{%s_%s.%s}\n", system_name, Representation, Language);
    }
# text files
    if( match("txt r m c",Language)>0) {
      print "\\section{" section_head "}";
      print "  \\begin{verbatim}";
      command = sprintf("cat %s_%s.%s", system_name, Representation, Language);
      system(command);
      print "  \\end{verbatim}";  
    }
# ps files
    if( match("ps",Language)>0) {
      print "\\section{" section_head "}";
      printf("This representation is given as Figure \\ref{fig:%s}.\n", Rep_lang);
      print "  \\begin{figure}";
      printf("    \\epsfig{file=%s_%s.%s,width=\\linewidth}\n", \
	     system_name, Representation, Language);
      printf("    \\caption{System %s, representation %s}\n", system_name, Representation);
      printf("    \\label{fig:%s}\n", Rep_lang);
      print "  \\end{figure}";
    }
  }
}
END {

}



