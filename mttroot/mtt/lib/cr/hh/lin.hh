#ifndef LIN_HH
#define LIN_HH

#include <iostream>

#include "components.hh"
// translated from lin.cr

// one 2-port, R/C/I; two 2-port, TF/GY
inline double
lin(const component_t	type,
    // parameters
    const causality_t	gain_causality,
    const double	gain,
    // output
    const causality_t	out_causality,
    const int		out_port,
    // input
    const double	input,
    const causality_t	in_causality,
    const int		in_port)
{
  if (out_port == in_port) {			  // R/C/I
    if (gain_causality == in_causality) {
      return input * gain;
    } else {
      return input / gain;
    }
  } else {					  // GY/TF
    if (out_causality == in_causality) {	// gyrator
      if ((out_port == 1 && out_causality != gain_causality)
	  ||(out_port == 2 && out_causality == gain_causality)) {
	return input * gain;
      } else {
	return input / gain;
      }
    } else {				// transformer
      if (out_causality == gain_causality) {
	return input * gain;
      } else {
	return input / gain;
      }
    }
  }
}

// two 2-port, AE/AF
inline double
lin(const component_t	type,
    // parameters
    const double	gain,
    // output
    const causality_t	out_causality,
    const int		out_port,
    // input
    const double	input,
    const causality_t	in_causality,
    const int		in_port)
{
  return
    (out_port == 1) ? input * gain :
    input / gain;
}




// three 2-port, FMR
inline double
lin(const component_t	type,
    // parameters
    const causality_t	gain_causality,
    const double	gain,
    // output
    const causality_t	out_causality,
    const int		out_port,
    // input
    const double	input,
    const causality_t	in_causality,
    const int		in_port,
    const double	modulation,
    const causality_t	mod_causality,
    const int		mod_port)
{
  if (mod_causality == flow) {		// uni-causal
    if (out_port == 2) {
      return 0;
    } else {
      double k = 1.0;
      if (gain_causality == in_causality) {
	k *= gain;
      } else {
	k /= gain;
      }
      if (in_causality == effort) {
	k *= modulation;
      } else {
	k /= modulation;
      }
      return input * k;
    }
  } else {				// bi-causal
    if ((in_causality == effort)
	&&(mod_causality == flow)
	&&(gain_causality == effort)
	&&(in_port == 1)
	&&(mod_port == 1)) {
      return (input / modulation) / gain;
    } else {

	// three 2-port, EMTF
	
	if ((out_causality == gain_causality && out_port == 2)
	    ||(out_causality != gain_causality && out_port == 1)) {
	  return input * gain * modulation;
	} else if((out_causality != gain_causality && out_port == 2)
		  ||(out_causality == gain_causality && out_port == 1)) {
	  return input / (gain * modulation);
	} else {
	  std::cerr << "* Error: __FILE__ does not cover this case" << std::endl;
	  exit(-1);
	}
    } // EMTF
  } // bi-causal
}


#endif // LIN_HH
