#include <octave/oct.h>

#ifdef	OCTAVE_DEV
#define VECTOR_VALUE column_vector_value
#else // !OCTAVE_DEV
#define	VECTOR_VALUE vector_value
#endif // OCTAVE_DEV

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
  ColumnVector  	x	= args(0).VECTOR_VALUE ();
  const ColumnVector	dx	= args(1).VECTOR_VALUE ();
  const double		ddt	= args(2).double_value ();
  const int		Nx	= static_cast<int> (args(3).double_value ());
  const ColumnVector   	openx	= args(4).VECTOR_VALUE ();
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
