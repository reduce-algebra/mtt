#include <octave/oct.h>

#ifdef STANDALONE
ColumnVector Fmtt_euler (      ColumnVector	&x,
			 const ColumnVector	&dx,
			 const double		&ddt,
			 const int		&Nx,
			 const ColumnVector	&openx)
{
#else // !STANDALONE
DEFUN_DLD (mtt_euler, args, ,
	   "euler integration method")
{
#ifdef OCTAVE_DEV
  static ColumnVector  	x	= args(0).column_vector_value ();
  const ColumnVector	dx	= args(1).column_vector_value ();
  const double		ddt	= args(2).double_value ();
  const int		Nx	= static_cast<int> (args(3).double_value ());
  const ColumnVector   	openx	= args(4).column_vector_value ();
#else // !OCTAVE_DEV
  static ColumnVector	x	= args(0).vector_value ();
  const ColumnVector   	dx	= args(1).vector_value ();
  const double		ddt	= args(2).double_value ();
  const int		Nx	= static_cast<int> (args(3).double_value ());
  const ColumnVector   	openx	= args(4).vector_value ();
#endif // OCTAVE_DEV
#endif // STANDALONE

  register int i, n;
  
  n = Nx;
  for (i = 0; i < Nx; i++)
    {
      if (0 != openx (i))
	{
	  x (i) = 0.0;
	}
      else
	{
	  x (i) += dx (i) * ddt;
	}
    }
#ifdef STANDALONE
  return x;
#else // !STANDALONE  
  return octave_value (x);
#endif // STANDALONE
}
