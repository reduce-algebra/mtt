#-------------------------------------------------------------------------------
#			Model Transformation Tools
#-------------------------------------------------------------------------------


package lcos;

#-------------------------------------------------------------------------------
#		linear constitutive relationship with cosine modulation
#-------------------------------------------------------------------------------

use strict;
use warnings;

#-------------------------------------------------------------------------------
# standard module header (see perlmod for explanation)
#-------------------------------------------------------------------------------
BEGIN {
    use Exporter   ();
    our ($VERSION, @ISA, @EXPORT, @EXPORT_OK, %EXPORT_TAGS);

    $VERSION     = 1.00;

    @ISA         = qw(Exporter);
    @EXPORT      = qw(&lcos);	# CR name
    %EXPORT_TAGS = ( );
}

#-------------------------------------------------------------------------------
# declaration of specific component implementations
#-------------------------------------------------------------------------------
sub lcos_emtf(@);		# EMTF

#-------------------------------------------------------------------------------
# main function: selects which subfunction to call
#-------------------------------------------------------------------------------
sub lcos (@) {

    my $retval;

    $_ = $_[0];

    s/\((.*)\)/$1/;		# strip brackets
    my @args = split (/,/);	# split arguments

    $_ = $args[0];		# get component type

    # select rule to use
    if (/^EMTF|emtf$/)	{ $retval = lcos_emtf	(@args); }
    
    # if a substitution has been made ($retval)
    if ($retval)
    {
	return $retval;		# return substituted expression
    }
    else			# return nothing
    {
	return;
    }
}

#-------------------------------------------------------------------------------
# EMTF
#-------------------------------------------------------------------------------
sub lcos_emtf (@) {

    my @args = @_;
    my $retval = '';

    if ($#args == 11-1)
    {
	my ($component,
	    $gain_causality,
	    $gain,
	    $out_causality,
	    $out_port,
	    $input,
	    $in_causality,
	    $in_port,
	    $mod_input,
	    $mod_causality,
	    $mod_port) = @args;

	if ((($mod_port == 3) and
	     ($out_causality eq $in_causality))
	    and
	    ((($out_causality eq $gain_causality) and
	      ($out_port == 2))
	     or
	     (($out_causality ne $gain_causality) and
	      ($out_port == 1))))
	{
	    $retval = "(($input)*($gain)*(cos($mod_input)))";
	}
	elsif ((($mod_port == 3) and
		($out_causality eq $in_causality))
	       and
	       ((($out_causality ne $gain_causality) and
		 ($out_port == 2))
		or
		(($out_causality eq $gain_causality) and
		 ($out_port == 1))))
	{
	    $retval = "(($input)/(($gain)*(cos($mod_input))))";
	}
    }
    
    if ($retval)
    {
	return $retval;
    }
    else
    {
	return;
    }
}

#-------------------------------------------------------------------------------
1;				# return true

