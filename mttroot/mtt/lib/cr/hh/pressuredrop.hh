#ifndef PRESSUREDROP_HH
#define PRESSUREDROP_HH

#include <cmath>		// fabs, pow
#include <string>

#include "constants.hh"
#include "frictionfactor.hh"
#include "kinematicviscosity.hh"
#include "sign.hh"

inline double
pressuredrop(const std::string fluid,
	     const double d,
	     const double l,
	     const double r,
	     const double rho,
	     const double T,
	     const double Q)
{
  double nu = kinematicviscosity(fluid, T);
  double Re = 4.0 * fabs(Q) / (pi * d * nu);
  double f = frictionfactor(Re, r);
  double k = 4.0 * f * l / d;
  double dP = k * 8.0 * rho * pow(Q, 2) / (pi2 * pow(d, 4));
  return (dP * sign(Q));
}

inline double
pressuredrop(const std::string fluid,
	     const double d,
	     const double l,
	     const double r,
	     const double rho,
	     const double T,
	     const causality_t effort_causality, const int port,
	     const double Q, const causality_t flow_causality, const int port_in)
{
  
  /* assert(effort == causality);
   * assert(flow == causality_in);
   * assert(1 == port_in);
   * assert(1 == port);
   */
  return pressuredrop(fluid, d, l, r, rho, T, Q);
}

#endif // PRESSUREDROP_HH
