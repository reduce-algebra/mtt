#ifndef FADE_HH
#define FADE_HH

#include <cmath>		// tanh

#include "constants.hh"		// pi

inline double
fade(const double x,
     const double x1,
     const double x2,
     const double y1,
     const double y2)
{
  /* fades two functions together smoothly over the range x1 to x2
   * function does not check that x2 > x1
   */
  double theta;
  theta = (x - x1) / (x2 - x1);		// map (linear)     {x1  , x2 } => {0   , +1 }
  theta = (theta - 0.5) * 2.0 * pi;	// map (linear)     {0   , +1 } => {-Pi , +Pi}
  theta = tanh(theta);			// map (non-linear) {-Pi , +Pi} => {-1  , +1 }
  theta = (theta + 1.0) / 2.0;		// map (linear)     {-1  , +1 } => {0   , +1 }

  return (theta * y1 + (1.0 - theta) * y2);
}

inline double
chkfade(const double x,
	const double x1,
	const double x2,
	const double y1,
	const double y2)
{
  double X1 = x1, X2 = x2;
  if (x1 > x2) {
    std::cerr << "* Warning: chkfade; x2 > x1, swapping" << std::endl;
    X1 = x2;
    X2 = x1;
  }
  return ((x <= X1) ? y1 : (x > X2) ? y2 : fade(x, X1, X2, y1, y2));
}

#endif // FADE_HH
