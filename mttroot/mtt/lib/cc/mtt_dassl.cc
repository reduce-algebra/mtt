
#include <octave/oct.h>
#include <octave/DASSL.h>


#ifdef  OCTAVE_DEV
#include <octave/parse.h>
#define VECTOR_VALUE column_vector_value
#else   // !OCTAVE_DEV
#include <octave/toplev.h>
#define VECTOR_VALUE vector_value
#endif  // OCTAVE_DEV

// Code generation directives
#define STANDALONE 0
#define OCTAVEDLD  1
#if (! defined (CODEGENTARGET))
#define CODEGENTARGET STANDALONE
#endif // (! defined (CODEGENTARGET))

#if (CODEGENTARGET == STANDALONE)
extern ColumnVector
Fmtt_residual (const ColumnVector &X, const ColumnVector &DX, double t, int &ires);
#endif // (CODEGENTARGET == STANDALONE)


ColumnVector
mtt_residual (const ColumnVector &X, const ColumnVector &DX, double t, int &ires)
{
#if (CODEGENTARGET == STANDALONE)
  return Fmtt_residual (X, DX, t, ires);
#elif (CODEGENTARGET == OCTAVEDLD)
  static octave_value_list args, f;
  args(0) = octave_value (X);
  args(1) = octave_value (DX);
  args(2) = octave_value (t);
  args(3) = octave_value (static_cast<double>(ires));
  f = feval ("mtt_residual", args, 1);
  return f(0).VECTOR_VALUE ();
#endif // (CODEGENTARGET == STANDALONE)
}


#if (CODEGENTARGET == STANDALONE)
ColumnVector
Fmtt_dassl (	  ColumnVector	&x,
	    const ColumnVector	&u,
	    const double	&t,
	    const ColumnVector	&par,
	    const ColumnVector	&dx,
	    const double	&ddt,
	    const int		Nx,
	    const int		Nyz,
	    const ColumnVector	&openx)
{
#elif (CODEGENTARGET == OCTAVEDLD)
DEFUN_DLD (mtt_dassl, args, ,
	   "dassl integration method")
{
  ColumnVector		x	= args(0).VECTOR_VALUE();
  const ColumnVector   	u	= args(1).VECTOR_VALUE();
  const double		t	= args(2).double_value();
  const ColumnVector	par	= args(3).VECTOR_VALUE();
  const ColumnVector	dx	= args(4).VECTOR_VALUE();
  const double		ddt	= args(5).double_value();
  const int		Nx	= static_cast<int> (args(6).double_value());
  const int		Nyz	= static_cast<int> (args(7).double_value());
  const ColumnVector	openx	= args(8).VECTOR_VALUE();
#endif // (CODEGENTARGET == STANDALONE)

  static DAEFunc fdae(mtt_residual);
  static ColumnVector XX (Nx+Nyz);
  XX.insert (x,0);

  for (register int i = Nx; i < Nx+Nyz; i++)
    XX(i) = 0.0;

  double tout = t + ddt;

  DASSL fdassl (XX, t, fdae);
  x = fdassl.do_integrate (tout).extract (0,Nx-1);

  for (register int i = 0; i < Nx; i++)
    if (openx (i) > 0.5)
      x (i) = 0.0;
      

#if (CODEGENTARGET == STANDALONE)
  return x;
#elif (CODEGENTARGET == OCTAVEDLD)
  return octave_value (x);
#endif // (CODEGENTARGET == STANDALONE)
}
