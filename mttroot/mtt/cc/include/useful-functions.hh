
#ifndef HAVE_USEFUL_FUNCTIONS_HH
#define HAVE_USEFUL_FUNCTIONS_HH

/* Code generation directives */
#define STANDALONE 0
#define OCTAVEDLD  1
#define MATLABMEX  2
#if (! defined (CODEGENTARGET))
#define CODEGENTARGET -1
#endif /* (! defined (CODEGENTARGET)) */

#ifndef __cplusplus
#define inline			/* strip */
#define cast_to_double	(double)
/*
typedef unsigned int bool;
const bool true = 1;
const bool false = 0;
*/
#else
#include <cmath>
#define cast_to_double	static_cast<double>
using std::pow;
#endif /* ! __cplusplus */

#ifdef M_PI
static double pi = M_PI;
static double Pi = M_PI;
static double PI = M_PI;
#else
static double pi = 3.1416;
static double Pi = pi;
static double PI = pi;
#endif

static inline double
max (const double x1, const double x2)
{
  return cast_to_double ((x1 >= x2) ? x1 : (x1 < x2) ? x2 : 0);
}

static inline double
min (const double x1, const double x2)
{
  return cast_to_double ((x1 <= x2) ? x1 : (x1 > x2) ? x2 : 0);
}

static inline double
nonsingular (const double x)
{
  return cast_to_double ((x == 0) ? 1.0e-30 : x);
}

static inline double
sign (const double x)
{
  return cast_to_double ((x > 0) ? +1 : (x < 0) ? -1 : 0);
}


/* Octave functions */
#if ((CODEGENTARGET == STANDALONE) || (CODEGENTARGET == OCTAVEDLD))
#ifdef __cplusplus
static Matrix
ones (const int r = 1, const int c = 1)
{
  Matrix m (r, c, 1.0);
  return m;
}

static ColumnVector
nozeros (const ColumnVector v0, const double tol = 0.0)
{
  ColumnVector v (v0.length ());
  register int i, j;
  for (i = j = 0; i < v.length (); i++)
    if (tol < std::abs (v0 (i)))
      {
	v (j) = v0 (i);
	j++;
      }
  if (0 == j)
    {
      return *new ColumnVector ();
    }
  else
    {
      return (v.extract (0, --j));
    }
}

static ColumnVector
zeros (const int r)
{
  ColumnVector v (r, 0.0);
  return v;
}

static Matrix
zeros (const int r, const int c)
{
  Matrix m (r, c, 0.0);
  return m;
}
#endif /* __cplusplus */
#endif /* ((CODEGENTARGET == STANDALONE) || (CODEGENTARGET == OCTAVEDLD)) */



#endif /* HAVE_USEFUL_FUNCTIONS_HH */

