//#define pi 3.14159 // Predefine pi

#ifndef HAVE_USEFUL_FUNCTIONS_HH
#define HAVE_USEFUL_FUNCTIONS_HH


#ifndef __cplusplus
#define inline			/* strip */
#endif // ! __cplusplus


static inline double
max (const double x1, const double x2)
{
  return static_cast<double>((x1 >= x2) ? x1 : (x1 < x2) ? x2 : 0);
}

static inline double
min (const double x1, const double x2)
{
  return static_cast<double>((x1 <= x2) ? x1 : (x1 > x2) ? x2 : 0);
}

static inline double
nonsingular (const double x)
{
  return static_cast<double>((x == 0) ? 1.0e-30 : x);
}

static inline double
sign (const double x)
{
  return static_cast<double>((x > 0) ? +1 : (x < 0) ? -1 : 0);
}


// Octave functions
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
#endif // __cplusplus



#endif // HAVE_USEFUL_FUNCTIONS_HH
