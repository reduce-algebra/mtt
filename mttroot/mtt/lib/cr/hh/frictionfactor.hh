#ifndef FRICTIONFACTOR_HH
#define FRICTIONFACTOR_HH

#include <iostream>
#include <math.h>
#include <string>

#include "constants.hh"		// ReL, ReT
#include "fade.hh"

inline double
frictionfactor(const double Re, const double r) {
  if (0.0 == Re) {
    return 0.0;
  }
  else if (ReL >= Re) {		// laminar flow
    return 16.0 / Re;		// using k = 4.f.(l/d)
  } else if (ReT <= Re) {	// turbulent flow
    /* S.E.Haaland
     * Simple and explicit formulas for the friction factor in turbulent pipe flow
     * Journal of Fluids Engineering, 105 (1983)
     */
    double A = 6.91 / Re;
    double B = pow((r / 3.71), 1.11);
    double f = pow(-3.6 * log10(A + B), -2);
    return f;
  } else {			// transition region 
    double ffL = frictionfactor(ReL, r);
    double ffT = frictionfactor(ReT, r);
    return fade(Re, ReL, ReT, ffL, ffT);
  }
}

#endif // FRICTIONFACTOR_HH
