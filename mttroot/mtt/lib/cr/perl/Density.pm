#-------------------------------------------------------------------------------
#			Model Transformation Tools
#-------------------------------------------------------------------------------


package mtt::Density;

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
    @EXPORT      = qw(&Density);	# CR name
    %EXPORT_TAGS = ( );
}

#-------------------------------------------------------------------------------
# declaration of specific component implementations
#-------------------------------------------------------------------------------
sub Density_r(@);		# R

#-------------------------------------------------------------------------------
# main function: selects which subfunction to call
#-------------------------------------------------------------------------------
sub Density (@) {

    my $retval;

    $_ = $_[0];

    s/\((.*)\)/$1/;		# strip brackets
    my @args = split (/,/);	# split arguments

    $_ = $args[0];		# get component type

    # select rule to use
    if (/^R|r$/)	{ $retval = Density_r	(@args); }
    
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
# R
#-------------------------------------------------------------------------------
sub Density_r (@) {

    my @args = @_;
    my $retval = '';
    
    if ($#args == 15-1)
    {
	if ($args[2] eq 'ideal_gas')
	{
	    my ($component,
		$required_output,
		$law,
		$R,
		$out_causality,
		$out_port,
		$Pressure,
		$P_causality,
		$P_port,
		$Temperature,
		$T_causality,
		$T_port,
		$Nothing,
		$N_causality,
		$N_port) = @args;
	    
	    if (($P_causality eq 'effort') and
		($P_port == 1) and
		($T_causality eq 'effort') and
		($T_port == 2) and
		($N_causality eq 'flow') and
		($N_port == 3))
	    {
		if ($required_output eq 'density')
		{
		    return "(($Pressure)/(($R)*($Temperature)))";
		}
		elsif ($required_output eq 'specific_volume')
		{
		    return "(($R)*($Temperature)/($Pressure))";
		}
	    }
	}
	elsif ($args[2] eq 'incompressible')
	{
	    my ($component,
		$required_output,
		$law,
		$rho,
		$out_causality,
		$out_port,
		$Pressure,
		$P_causality,
		$P_port,
		$Temperature,
		$T_causality,
		$T_port,
		$Nothing,
		$N_causality,
		$N_port) = @args;
	    
	    if (($P_causality eq 'effort') and
		($P_port == 1) and
		($T_causality eq 'effort') and
		($T_port == 2) and
		($N_causality eq 'flow') and
		($N_port == 3))
	    {
		if ($required_output eq 'density')
		{
		    return "($rho)";
		}
		elsif ($required_output eq 'specific_volume')
		{
		    return "(1/($rho))";
		}
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

