#ifndef SQUARELAW_HH
#define SQUARELAW_HH

#include <math.h>
#include "sign.hh"

inline double squarelaw(const double gain,
			const causality_t causality, const int port,
			const double input, const causality_t in_causality, const int in_port)
  /*
   * implements P = R Q^2
   * direction of flow is retained
   */
{
  if (causality == effort) {
    return pow(input, 2) * gain * sign(input * gain);
  } else {
    return sqrt(fabs(input / gain)) * sign(input / gain);
  }
}

#endif // SQUARELAE_HH
