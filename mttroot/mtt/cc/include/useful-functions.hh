// $Id$
// $Log$
// Revision 1.1  2000/11/28 04:50:29  geraint
// Initial revision
//

inline Matrix
ones (const int r = 1, const int c = 1)
{
  Matrix m (r, c);
  register int i, j;
  for (i = 0; i < r; i++)
    for (j = 0; j < c; j++)
      m (i, j) = 1.0;
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
  return (j)
    ? (v.extract (0, --j))
    : 0x0;
}

inline ColumnVector
zeros (const int r)
{
  ColumnVector v (r);
  register int i;
  for (i = 0; i < r; i++)
    v (i) = 0.0;
  return v;
}

inline Matrix
zeros (const int r, const int c)
{
  Matrix m (r, c);
  register int i, j;
  for (i = 0; i < r; i++)
    for (j = 0; j < c; j++)
      m (i, j) = 0.0;
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


