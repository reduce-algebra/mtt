#-------------------------------------------------------------------------------
#			Model Transformation Tools
#-------------------------------------------------------------------------------


package rotate_z;

#-------------------------------------------------------------------------------
#		rotation of x-y plane about z
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
    @EXPORT      = qw(&rotate_z);	# CR name
    %EXPORT_TAGS = ( );
}

#-------------------------------------------------------------------------------
# declaration of specific component implementations
#-------------------------------------------------------------------------------
sub rotate_z_R(@);		# R

#-------------------------------------------------------------------------------
# main function: selects which subfunction to call
#-------------------------------------------------------------------------------
sub rotate_z (@) {

    my $retval;

    $_ = $_[0];

    s/\((.*)\)/$1/;		# strip brackets
    my @args = split (/,/);	# split arguments

    $_ = $args[0];		# get component type

    # select rule to use
    if (/^R|r$/)	{ $retval = rotate_z_R	(@args); }
    
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
sub rotate_z_R (@) {

    my @args = @_;
    my $retval = '';

    if ($#args == 18-1)
    {
	my ($component,
	    $out_causality, $out_port,
	    $x1, $causality1, $port1,
	    $y1, $causality2, $port2,
	    $x2, $causality3, $port3,
	    $y2, $causality4, $port4,
	    $psi, $causality5, $port5) = @args;

	# [ x2 ]   [ +cos(psi) +sin(psi) 0 ] [ x1 ]
	# [ y2 ] = [ -sin(psi) +cos(psi) 0 ] [ y1 ]
	# [ z2 ]   [    0          0     1 ] [ z1 ]

	# for reverse transformation (x2->x1) use psi=-psi
	# note that cos(-psi)=cos(psi) and sin(-psi)=-sin(psi)

	if ($out_port == 1)	# x1
	{
	    $retval = "(($x2)*(+cos($psi))+($y2)*(-sin($psi)))";
	}
	elsif ($out_port == 2)	# y1
	{
	    $retval = "(($x2)*(+sin($psi))+($y2)*(+cos($psi)))";
	}
	elsif ($out_port == 3)	# x2
	{
	    $retval = "(($x1)*(+cos($psi))+($y1)*(+sin($psi)))";
	}
	elsif ($out_port == 4)	# y2
	{
	    $retval = "(($x1)*(-sin($psi))+($y1)*(+cos($psi)))";
	}
	elsif ($out_port == 5)
	{
	    $retval = "(0)";
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

