#include <octave/oct.h>
#include "useful-functions.hh"

#include <octave/xdiv.h>
static inline int
result_ok (int info, double rcond, int warn = 1)
{
  assert (info != -1);

  if (info == -2)
    {
      if (warn)
	warning ("matrix singular to machine precision, rcond = %g", rcond);
      else
	error ("matrix singular to machine precision, rcond = %g", rcond);

      return 0;
    }
  else
    return 1;
}
bool
mx_leftdiv_conform (const Matrix& a, const ColumnVector& b)
{
  int a_nr = a.rows ();
  int b_nr = b.length ();

  if (a_nr != b_nr)
    {
      int a_nc = a.cols ();
      int b_nc = 1;

      gripe_nonconformant ("operator \\", a_nr, a_nc, b_nr, b_nc);
      return false;
    }

  return true;
}

// need to update xdiv.cc ?
inline ColumnVector
ldiv (const Matrix &a, const ColumnVector &b)
{
  if (! mx_leftdiv_conform (a, b))
    return ColumnVector ();

  int info;
  if (a.rows () == a.columns ())
    {
      double rcond = 0.0;
      ColumnVector result = a.solve (b, info, rcond);
      if (result_ok (info, rcond))
	return result;
    }

  int rank;
  return a.lssolve (b, info, rank);
}

DEFUN_DLD (mtt_implicit, args, ,
	   "implicit integration method")
{
#ifdef OCTAVE_DEV
  static ColumnVector  	x	= args(0).column_vector_value ();
  const ColumnVector	dx	= args(1).column_vector_value ();
  const Matrix		AA	= args(2).matrix_value ();
  const ColumnVector	AAx	= args(3).column_vector_value ();
  const double		t	= args(4).double_value ();
  const int		Nx	= (int) (args(5).double_value ());
  const ColumnVector	openx	= args(6).column_vector_value ();
#else
  static ColumnVector	x	= args(0).vector_value ();
  const ColumnVector	dx	= args(1).vector_value ();
  const Matrix		AA	= args(2).matrix_value ();
  const ColumnVector	AAx	= args(3).vector_value ();
  const double		t	= args(4).double_value ();
  const int		Nx	= (int) (args(5).double_value ());
  const ColumnVector	openx	= args(6).vector_value ();
#endif

  register int i, n;
  register int col_old, col_new;
  register int row_old, row_new;

  n = Nx;
  for (i = 0; i < Nx; i++)
    {
      if (0 != openx (i))
	{
	  n--;
	}
    }

  static ColumnVector	tmp_dx	(n);
  static ColumnVector	tmp_x	(n);
  static ColumnVector	tmp_AAx	(n);
  static Matrix	tmp_AA	(n, n);

  for (row_new = row_old = 0; row_old < Nx; row_old++)
    {
      if (0 == openx (row_old))
	{
	  tmp_dx  (row_new)	= dx  (row_old);
	  tmp_AAx (row_new)	= AAx (row_old);
	  for (col_new = col_old = 0; col_old < Nx; col_old++)
	    {
	      if (0 == openx (col_old))
		{
		  // xxx: this can be improved by symmetry
		  tmp_AA (row_new,col_new) = AA (row_old,col_old);
		  col_new++;
		}
	    }
	  row_new++;
	}
    }

  // can't get ldiv to work - doesn't like ColVector
  // tmp_x = tmp_AA.pseudo_inverse () * tmp_AAx + t * tmp_dx;
  tmp_x = ldiv (tmp_AA, (tmp_AAx + t * tmp_dx));
  
  row_new = 0;
  for (row_old = 0; row_old < Nx; row_old++)
    {
      if (0 == openx (row_old))
	{
	  x (row_old) = tmp_x (row_new);
	  row_new++;
	}
      else
	{
	  x (row_old) = 0.0;
	}
    }

  return octave_value (x);
}


