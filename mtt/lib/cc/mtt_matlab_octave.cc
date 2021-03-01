
#include <octave/oct.h>
#include <mex.h>


// conversions from Matlab mxArray* to Octave data types

Matrix
mtt_Matrix (const mxArray *m)
{
  const unsigned long int nrows = mxGetM (m);
  const unsigned long int ncols = mxGetN (m);
  Matrix o (nrows, ncols);
  const double *p = mxGetPr (m);
  for (unsigned long int row = 0; row < nrows; row++)
    for (unsigned long int col = 0; col < ncols; col++)
      o (row, col) = p[row + nrows*col];
  return (o);
}

ColumnVector
mtt_ColumnVector (const mxArray *m)
{
  const unsigned long int nrows = mxGetM (m);
  ColumnVector o (nrows);
  const double *p = mxGetPr (m);
  for (unsigned long int row = 0; row < nrows; row++)
    o (row) = p[row];
  return (o);
}

const double
mtt_double (const mxArray *m)
{
  const double *p = mxGetPr (m);
  return (*p);
}


// conversions from Octave data types to Matlab mxArray*

mxArray *
mtt_mxArray (const Matrix &o)
{
  const unsigned long int nrows = o.rows ();
  const unsigned long int ncols = o.columns ();
  mxArray *m;
  m = mxCreateDoubleMatrix (nrows, ncols, mxREAL);
  double *p = mxGetPr (m);
  for (unsigned long int row = 0; row < nrows; row++)
    for (unsigned long int col = 0; col < ncols; col++)
      p [row + nrows*col] = o (row, col);
  return (m);
}

mxArray *
mtt_mxArray (const ColumnVector &o)
{
  const unsigned long int nrows = o.length ();
  mxArray *m;
  m = mxCreateDoubleMatrix (nrows, 1, mxREAL);
  double *p = mxGetPr (m);
  for (unsigned long int row = 0; row < nrows; row++)
    p [row] = o (row);
  return (m);
}
