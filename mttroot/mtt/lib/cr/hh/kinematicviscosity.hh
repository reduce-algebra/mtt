#ifndef KINEMATICVISCOSITY_HH
#define KINEMATICVISCOSITY_HH

#include <math.h>		// pow
#include <string>

inline double
kerosenekinematicviscosity(const double T)
  /*
   * B.S.Massey
   * Mechanics of fluids
   * ISBN: 0 412 34280 4
   * log-log plot of kinematic viscosity versus temperature is linear for kerosene
   * L(n) = log10(n)
   *
   * T =   0 deg C : nu = 4.0 mm2/s
   * T = 100 deg C : nu = 0.9 mm2/s
   *
   * deg C => K, mm2/s => m2/s
   *
   * T1 = 273.15 : nu1 = 4.0e-6 m2/s
   * T2 = 373.15 : nu2 = 0.9e-6 m2/s
   *
   * L(nu) = m L(T) + c
   *
   *    m = (L(nu2) - L(nu1)) / (L(T2) - L(T1))
   *      = L(nu2/nu1) / L(T2/T1)
   *      = L(0.9/4.0) / L(373.15/273.15)
   *      = -4.781567507
   *
   *    c = L(nu1) - m * L(T1)
   *      = L(4.0e-6) - m * L(273.15)
   *      = 6.251876827 
   *
   * nu {m2/s} = 10^(m * L(T {Kelvin}) + c)
   *
   *    = 10^(m * L(T) + c)
   *    = 10^c * (10^L(T))^m
   *    = 10^c * T^m
   *
   * 10^c = 1.78598097e6
   * 
   * nu = 1.78598097e6 * T^(-4.781567507)
   */
{
  return 1.79e6 * pow(T, -4.78);
}

inline double
kinematicviscosity(const string fluid,
		   const double T)
{
  if ("kerosene" == fluid) {
    return kerosenekinematicviscosity(T);
  } else {
    cerr << __FILE__ << ": fluid \"" << fluid << "\" unknown" << endl;
    exit(-1);
  }
}

#endif // KINEMATICVISCOSITY_HH
