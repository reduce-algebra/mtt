#include <octave/oct.h>
#include <octave/xdiv.h>

#ifdef STANDALONE
ColumnVector Fmtt_implicit (      ColumnVector	&x,
			    const ColumnVector	&dx,
			    const Matrix	&AA,
			    const ColumnVector	&AAx,
			    const double	&t,
			    const int		&Nx,
			    const ColumnVector	&openx)
{
#else // !STANDALONE
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
#else // !OCTAVE_DEV
  static ColumnVector	x	= args(0).vector_value ();
  const ColumnVector	dx	= args(1).vector_value ();
  const Matrix		AA	= args(2).matrix_value ();
  const ColumnVector	AAx	= args(3).vector_value ();
  const double		t	= args(4).double_value ();
  const int		Nx	= (int) (args(5).double_value ());
  const ColumnVector	openx	= args(6).vector_value ();
#endif // OCTAVE_DEV
#endif // STANDALONE

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

  static Matrix	tmp_dx	(n,1);
  static Matrix	tmp_x	(n,1);
  static Matrix	tmp_AAx	(n,1);
  static Matrix	tmp_AA	(n,n);

  for (row_new = row_old = 0; row_old < Nx; row_old++)
    {
      if (0 == openx (row_old))
	{
	  tmp_dx  (row_new,0)	= dx  (row_old);
	  tmp_AAx (row_new,0)	= AAx (row_old);
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

  tmp_x = xleftdiv (tmp_AA, (tmp_AAx + tmp_dx * t));
  
  row_new = 0;
  for (row_old = 0; row_old < Nx; row_old++)
    {
      if (0 == openx (row_old))
	{
	  x (row_old) = tmp_x (row_new,0);
	  row_new++;
	}
      else
	{
	  x (row_old) = 0.0;
	}
    }

#ifdef STANDALONE
  return x;
#else // !STANDALONE
  return octave_value (x);
#endif // STANDALONE
}
