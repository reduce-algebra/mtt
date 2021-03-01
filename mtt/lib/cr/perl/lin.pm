#-------------------------------------------------------------------------------
#			Model Transformation Tools
#-------------------------------------------------------------------------------


package mtt::lin;

#-------------------------------------------------------------------------------
#		Default linear constitutive relationship
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
    @EXPORT      = qw(&lin);	# CR name
    %EXPORT_TAGS = ( );
}

#-------------------------------------------------------------------------------
# declaration of specific component implementations
#-------------------------------------------------------------------------------
sub lin_amp (@);		# AE AF
sub lin_cir (@);		# C I R
sub lin_emtf(@);		# EMTF
sub lin_fmr (@);		# FMR
sub lin_gy  (@);		# GY
sub lin_tf  (@);		# TF

#-------------------------------------------------------------------------------
# main function: selects which subfunction to call
#-------------------------------------------------------------------------------
sub lin (@) {

    my $retval;

    $_ = $_[0];

    s/\((.*)\)/$1/;		# strip brackets
    my @args = split (/,/);	# split arguments

    $_ = $args[0];		# get component type

    # select rule to use
    if (/^AE|ae$/)	{ $retval = lin_amp	(@args); }
    if (/^AF|af$/)	{ $retval = lin_amp	(@args); }
    if (/^C|c$/)	{ $retval = lin_cir	(@args); }
    if (/^EMTF|emtf$/)	{ $retval = lin_emtf	(@args); }
    if (/^FMR|fmr$/)	{ $retval = lin_fmr	(@args); }
    if (/^GY|gy$/)	{ $retval = lin_gy	(@args); }
    if (/^I|i$/)	{ $retval = lin_cir	(@args); }
    if (/^R|r$/)	{ $retval = lin_cir	(@args); }
    if (/^TF|tf$/)	{ $retval = lin_tf	(@args); }
    
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
# AE and AF
#-------------------------------------------------------------------------------
sub lin_amp (@) {

    my @args = @_;
    my $retval = '';

    if ($#args == 8-1) {

	my ($component,
	    $gain_causality,
	    $gain,
	    $out_causality,
	    $out_port,
	    $input,
	    $in_causality,
	    $in_port) = @args;

	if (($out_port == 2) and
	    ($in_port  == 1))
	{			# uni-causal
	    $retval = "(($input)*($gain))";
	}

	elsif (($out_port == 1) and
	       ($in_port  == 2))
	{			# bi-causal
	    $retval = "(($input)/($gain))";
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
# C, I and R
#-------------------------------------------------------------------------------
sub lin_cir (@) {

    my @args = @_;
    my $retval = '';

    if ($#args == 8-1)
    {
	my ($component,
	    $gain_causality,
	    $gain,
	    $out_causality,
	    $out_port,
	    $input,
	    $in_causality,
	    $in_port) = @args;
	
	if (
	    ($out_port == 1)
	    and
	    ($in_port  == 1)
	    )
	{			# single port	    
	    if ($in_causality eq $gain_causality)
	    {
		$retval = "(($input)*($gain))";
	    }	    
	    elsif ($in_causality ne $gain_causality)
	    {
		$retval = "(($input)/($gain))";
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
# EMTF
#-------------------------------------------------------------------------------
sub lin_emtf (@) {

    my @args = @_;
    my $retval = '';

    if ($#args == 10-1)
    {				# modulation only
	my ($component,
	    $gain_causality,
	    $out_causality,
	    $out_port,
	    $input,
	    $in_causality,
	    $in_port,
	    $mod_input,
	    $mod_causality,
	    $mod_port) = @args;

	if ((($mod_causality eq 'effort') and
	     ($mod_port == 3))
	    and
	    ((($out_causality eq $gain_causality) and
	      ($out_port == 2))
	     or
	     (($out_causality ne $gain_causality) and
	      ($out_port == 1))))
	{
	    $retval = "(($input)*($mod_input))";
	}
	elsif ((($mod_causality eq 'effort') and
		($mod_port == 3))
	       and
	       ((($out_causality ne $gain_causality) and
		 ($out_port == 2))
		or
		(($out_causality eq $gain_causality) and
		 ($out_port == 1))))
	{
	    $retval = "(($input)/($mod_input))";
	}
    }
    elsif ($#args == 11-1)
    {				# modulation and gain
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

	if ((($mod_causality eq 'effort') and
	     ($mod_port == 3))
	    and
	    ((($out_causality eq $gain_causality) and
	      ($out_port == 2))
	     or
	     (($out_causality ne $gain_causality) and
	      ($out_port == 1))))
	{
	    $retval = "(($input)*(($gain)*($mod_input)))";
	}
	elsif ((($mod_causality eq 'effort') and
		($mod_port == 3))
	       and
	       ((($out_causality ne $gain_causality) and
		 ($out_port == 2))
		or
		(($out_causality eq $gain_causality) and
		 ($out_port == 1))))
	{
	    $retval = "(($input)/(($gain)*($mod_input)))";
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
# FMR
#-------------------------------------------------------------------------------
sub lin_fmr (@) {

    my @args = @_;
    my $retval = '';

    if ($#args == 7-1)
    {				# uni-causal
	# flow modulation multiplies effort on port 1 (or divides flow)
	my ($component,
	    $gain_causality,
	    $gain,
	    $out_causality,
	    $input,
	    $in_causality,
	    $mod_input) = @args;

	if (($gain_causality eq $in_causality) and
	    ($out_causality eq 'flow'))
	{
	    $retval = "(($input)*($gain)*($mod_input))";
	}
	elsif (($gain_causality eq $in_causality) and
	       ($out_causality eq 'effort'))
	{
	    $retval = "(($input)*($gain)/($mod_input))";
	}
	elsif (($gain_causality ne $in_causality) and
	       ($out_causality eq 'flow'))
	{
	    $retval = "(($input)*($mod_input)/($gain))";
	}
	elsif (($gain_causality ne $in_causality) and
	       ($out_causality eq 'effort'))
	{
	    $retval = "(($input)/(($gain)*($mod_input)))";
	}
    }
    elsif ($#args == 11-1)
    {				# bi-causal
	# deduces the flow on port 2
	my ($component,
	    $gain_causality,
	    $gain,
	    $out_causality,
	    $out_port,
	    $e_input,
	    $e_causality,
	    $e_port,
	    $f_input,
	    $f_causality,
	    $f_port) = @args;

	if (($gain_causality eq 'effort') and
	    ($out_causality eq 'flow') and
	    ($out_port == 2) and
	    ($e_causality eq 'effort') and
	    ($e_port == 1) and
	    ($f_causality eq 'flow') and
	    ($f_port == 1))
	{
	    $retval = "((($f_input)/($e_input))/($gain))";
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
# GY
#-------------------------------------------------------------------------------
sub lin_gy (@) {

    my @args = @_;
    my $retval = '';

    if ($#args == 8-1)
    {
	my ($component,
	    $gain_causality,
	    $gain,
	    $out_causality,
	    $out_port,
	    $input,
	    $in_causality,
	    $in_port) = @args;

	if (($out_causality ne $in_causality) and
	    ($out_port != $in_port)
	    and
	    (($out_causality ne $gain_causality) and
	     ($out_port == 2))
	    or
	    (($out_causality ne $gain_causality) and
	     ($out_port == 1)))
	{
	    $retval = "(($input)/($gain))";
	}

	elsif (($out_causality ne $in_causality) and
	       ($out_port != $in_port)
	       and
	       (($out_causality eq $gain_causality) and
		($out_port == 2))
	       or
	       (($out_causality eq $gain_causality) and
		($out_port == 1)))
	{
	    $retval = "(($input)*($gain))";
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
# TF
#-------------------------------------------------------------------------------
sub lin_tf (@) {

    my @args = @_;
    my $retval = '';

    if ($#args == 8-1)
    {
	my ($component,
	    $gain_causality,
	    $gain,
	    $out_causality,
	    $out_port,
	    $input,
	    $in_causality,
	    $in_port) = @args;

	if (($out_causality eq $in_causality) and
	    ($out_port ne $in_port)
	    and
	    (($out_causality eq $gain_causality) and
	     ($out_port == 2))
	    or
	    (($out_causality ne $gain_causality) and
	     ($out_port == 1)))
	{
	    $retval = "(($input)*($gain))";
	}
	
	elsif (($out_causality eq $in_causality) and
	       ($out_port ne $in_port)
	       and
	       (($out_causality ne $gain_causality) and
		($out_port == 2))
	       or
	       (($out_causality eq $gain_causality) and
		($out_port == 1)))
	{
	    $retval = "(($input)/($gain))";
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

