#include <octave/oct.h>

DEFUN_DLD (mtt_euler, args, ,
	   "euler integration method")
{
#ifdef OCTAVE_DEV
  ColumnVector		x	= args(0).column_vector_value ();
  const ColumnVector	dx	= args(1).column_vector_value ();
  const double		ddt	= args(2).double_value ();
  const int		Nx	= static_cast<int> (args(3).double_value ());
  const ColumnVector   	openx	= args(4).column_vector_value ();
#else
  const ColumnVector	x	= args(0).vector_value ();
  const ColumnVector   	dx	= args(1).vector_value ();
  const double		ddt	= args(2).double_value ();
  const int		Nx	= static_cast<int> (args(3).double_value ());
  const ColumnVector   	openx	= args(4).vector_value ();
#endif

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
  
  return octave_value (x);
}
