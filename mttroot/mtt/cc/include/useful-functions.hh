
template <class T>
inline T max (const T &x1, const T &x2)
{
  return (x1 >= x2) ? x1 : (x2 < x1) ? x2 : 0;
}

template <class T>
inline T min (const T &x1, const T &x2)
{
  return (x1 <= x2) ? x1 : (x2 > x1) ? x2 : 0;
}

inline Matrix
ones (const int r = 1, const int c = 1)
{
  Matrix m (r, c, 1.0);
  return m;
}

inline ColumnVector
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

inline ColumnVector
zeros (const int r)
{
  ColumnVector v (r, 0.0);
  return v;
}

inline Matrix
zeros (const int r, const int c)
{
  Matrix m (r, c, 0.0);
  return m;
}

template <class T>
inline int
sign (T x)
{
  return
    (0 < x) ? +1 :
    (0 > x) ? -1 :
    0;
}
