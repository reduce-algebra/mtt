#include <octave/oct.h>
#include <octave/xdiv.h>

#ifdef STANDALONE
ColumnVector Fmtt_implicit (      ColumnVector	&x,
				  ColumnVector	&dx,
			          Matrix	&AA,
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

  register int row, col;

  for (row = 0; row < Nx; row++)
    {
      if (0 != openx (row))
	{
          dx (row) = 0.0;
	  for (col = 0; col < Nx; col++)
	    {
	      AA (row,col) = AA (col,row) = 0.0;
	    }
	}
    }

  x = static_cast<ColumnVector> (xleftdiv (AA, static_cast<Matrix>(AAx + dx * t)));
  
  for (row = 0; row < Nx; row++)
    {
      if (0 != openx (row))
	{
	  x (row) = 0.0;
	}
    }

#ifdef STANDALONE
  return x;
#else // !STANDALONE
  return octave_value (x);
#endif // STANDALONE
}