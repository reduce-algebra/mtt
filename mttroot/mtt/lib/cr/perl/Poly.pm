#-------------------------------------------------------------------------------
#			Model Transformation Tools
#-------------------------------------------------------------------------------


package mtt::Poly;

#-------------------------------------------------------------------------------
#		Polytropic constitutive relationship 
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
    @EXPORT      = qw(&Poly);	# CR name
    %EXPORT_TAGS = ( );
}

#-------------------------------------------------------------------------------
# declaration of specific component implementations
#-------------------------------------------------------------------------------
sub Poly_any(@);		# any component

#-------------------------------------------------------------------------------
# main function: selects which subfunction to call
#-------------------------------------------------------------------------------
sub Poly (@) {

    my $retval;

    $_ = $_[0];

    s/\((.*)\)/$1/;		# strip brackets
    my @args = split (/,/);	# split arguments

    $_ = $args[0];		# get component type

    # select rule to use
    $retval = Poly_any	(@args);
    
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
# any component
#-------------------------------------------------------------------------------
sub Poly_any (@) {

    my @args = @_;
    my $retval = '';

    if ($#args == 16-1)
    {
	my ($component,
	    $alpha,
	    $out_causality,
	    $out_port,
	    $P1,
	    $in1_causality,
	    $in1_port,
	    $P2,
	    $in2_causality,
	    $in2_port,
	    $T1,
	    $in3_causality,
	    $in3_port,
	    $Nothing,
	    $in4_causality,
	    $in4_port) = @args;

	if (($in1_port == 1) and
	    ($in1_causality eq 'effort') and
	    ($in2_port == 2) and
	    ($in2_causality eq 'effort') and
	    ($in3_port == 3) and
	    ($in3_causality eq 'effort') and
	    ($in4_port == 4) and
	    ($in4_causality eq 'flow'))
	{
	    if ($out_port != 4)
	    {
		return "(0)";
	    }
	    elsif ($out_causality eq 'effort')
	    {
		# return temperature T2
		$retval = "($T1)*pow((($P2)/($P1)),($alpha))";
	    }
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

