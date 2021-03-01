#ifndef STATICPRESSURE_HH
#define STATICPRESSURE_HH

#include <cmath>		// log, pow

#include "causality.hh"
#include "constants.hh"

inline double
staticpressure(const double beta,
	       const double C_d,
	       const double d,
	       const double P_ref,
	       const double rho,
	       const causality_t causality, const int port,
	       const double Q1, const causality_t causality1, const int port1,
	       const double Q2, const causality_t causality2, const int port2)
{
  static double P;
  if (0.0 != Q1 && 0.0 != Q2) {
    double num = pi2 * pow(d, 4) * log(Q1 / Q2);
    double den = 8.0 * beta * rho * Q1 * (Q2 - Q1 + C_d * (Q1 + Q2) / 2.0);
    P = P_ref + log(num / den)/beta;
  }
    return P;
}

#endif // STATICPRESSUE_HH
