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
###############################################################


BEGIN {
  split(ARGV[1],a,"_");
  system_name = a[1];
  args = ARGV[2];
}
{
  if (NF==2) {
# tex files
    if( match("tex",$2)>0) {
      print "\\section{Representation " $1 ", language " $2 "}";
      printf("  \\input{%s_%s.%s}\n", system_name, $1, $2);
    }
# text files
    if( match("txt r m",$2)>0) {
      print "\\section{Representation " $1 ", language " $2 "}";
      print "  \\begin{verbatim}";
      command = sprintf("cat %s_%s.%s", system_name, $1, $2);
      system(command);
      print "  \\end{verbatim}";  
    }
# ps files
    if( match("ps",$2)>0) {
      print "\\section{Representation " $1 ", language " $2 "}";
      printf("This representation is given as Figure \\ref{fig:%s}.\n", $1);
      print "  \\begin{figure}";
      printf("    \\epsfig{file=%s_%s.%s,width=\\linewidth}\n", \
	     system_name,  $1, $2);
      printf("    \\caption{System %s, representation %s}\n", system_name, $1);
      printf("    \\label{fig:%s}\n", system_name, $1);
      print "  \\end{figure}";
    }
  }
}
END {

}



