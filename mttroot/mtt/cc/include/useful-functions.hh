#ifndef HAVE_USEFUL_FUNCTIONS_HH
#define HAVE_USEFUL_FUNCTIONS_HH


#ifdef __CPLUSPLUS
template <class class_t>
#else
#define inline			// strip from pre-processed file
#define class_t double
#endif // __CPLUSPLUS

#ifndef MTT_UNUSED
#ifdef __GNUC__
#define MTT_UNUSED __attribute__ ((unused))
#else
#define MTT_UNUSED
#endif // __GNUC__
#endif // MTT_UNUSED

// == Template functions ==

static inline class_t max (const class_t &x1, const class_t &x2) MTT_UNUSED;
static inline class_t min (const class_t &x1, const class_t &x2) MTT_UNUSED;
static inline class_t sign (const class_t &x) MTT_UNUSED;

class_t
max (const class_t &x1, const class_t &x2)
{
  return ((x1 >= x2) ? x1 : (x1 < x2) ? x2 : 0);
}

class_t
min (const class_t &x1, const class_t &x2)
{
  return ((x1 <= x2) ? x1 : (x1 > x2) ? x2 : 0);
}

class_t
sign (const class_t &x)
{
  return ((x > 0) ? +1 : (x < 0) ? -1 : 0);
}


// == Octave functions ==

static inline Matrix ones (const int r = 1, const int c = 1) MTT_UNUSED;
static inline ColumnVector nozeros (const ColumnVector v0, const double tol = 0.0) MTT_UNUSED;
static inline ColumnVector zeros (const int r) MTT_UNUSED;
static inline Matrix zeros (const int r, const int c) MTT_UNUSED;

Matrix
ones (const int r = 1, const int c = 1)
{
  Matrix m (r, c, 1.0);
  return m;
}

ColumnVector
nozeros (const ColumnVector v0, const double tol = 0.0)
{
  ColumnVector v (v0.length ());
  register int i, j;
  for (i = j = 0; i < v.length (); i++)
    if (tol < abs (v0 (i)))
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

ColumnVector
zeros (const int r)
{
  ColumnVector v (r, 0.0);
  return v;
}

Matrix
zeros (const int r, const int c)
{
  Matrix m (r, c, 0.0);
  return m;
}

#endif // HAVE_USEFUL_FUNCTIONS_HH
