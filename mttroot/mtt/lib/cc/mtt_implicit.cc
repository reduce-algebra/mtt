#include <octave/oct.h>
#include <octave/xdiv.h>

#ifdef STANDALONE
ColumnVector Fmtt_implicit (      ColumnVector	&x,
				  ColumnVector	&dx,
			          Matrix	&AA,
				  ColumnVector	&AAx,
			    const double	&t,
			    const int		&Nx,
			    const ColumnVector	&openx)
{
#else // !STANDALONE
DEFUN_DLD (mtt_implicit, args, ,
	   "implicit integration method")
{
#ifdef OCTAVE_DEV
  ColumnVector  	x	= args(0).column_vector_value ();
  ColumnVector		dx	= args(1).column_vector_value ();
  Matrix		AA	= args(2).matrix_value ();
  ColumnVector		AAx	= args(3).column_vector_value ();
  const  double		t	= args(4).double_value ();
  const  int		Nx	= (int) (args(5).double_value ());
  const  ColumnVector	openx	= args(6).column_vector_value ();
#else // !OCTAVE_DEV
  ColumnVector		x	= args(0).vector_value ();
  ColumnVector		dx	= args(1).vector_value ();
  Matrix		AA	= args(2).matrix_value ();
  ColumnVector		AAx	= args(3).vector_value ();
  const  double		t	= args(4).double_value ();
  const  int		Nx	= (int) (args(5).double_value ());
  const  ColumnVector	openx	= args(6).vector_value ();
#endif // OCTAVE_DEV
#endif // STANDALONE

  register int row, col;

  for (row = 0; row < Nx; row++)
    {
      if (openx (row) > 0.5)
	{
	  AAx (row) = 0.0;
          dx (row) = 0.0;
	  for (col = 0; col < Nx; col++)
	    {
	      AA (row,col) = 0.0;
	      AA (col,row) = 0.0;
	    }
	}
    }

#ifdef OCTAVE_DEV
  x = static_cast<ColumnVector> (xleftdiv (AA, static_cast<Matrix>(AAx + dx * t)));
#else // !OCTAVE_DEV
  Matrix tmp = xleftdiv (AA, static_cast<Matrix>(static_cast<ColumnVector>(AAx + dx * t)));
  for (row = 0; row < Nx; row++)
    {
      x (row) = tmp (row,0);
    }
#endif // OCTAVE_DEV
  
  for (row = 0; row < Nx; row++)
    {
      if (openx (row) > 0.5)
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
