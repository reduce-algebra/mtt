#include <octave/oct.h>

#include <octave/toplev.h>
#include <octave/LSODE.h>
#include <octave/ov-struct.h>
#include <octave/oct-map.h>

#include "rc_def.h"
#include "rc_sympar.h"

octave_value_list
mtt_csex (ColumnVector x, ColumnVector u, double t, ColumnVector par)
{
  octave_value_list args, f;
  args (0) = octave_value (x);
  args (1) = octave_value (u);
  args (2) = octave_value (t);
  args (3) = octave_value (par);
  f = feval ("rc_csex", args, 2);
  return (f);
}

ColumnVector
mtt_cseo (ColumnVector x, ColumnVector u, double t, ColumnVector par)
{
  octave_value_list args;
  args (0) = octave_value (x);
  args (1) = octave_value (u);
  args (2) = octave_value (t);
  args (3) = octave_value (par);
  ColumnVector f;
  f = feval ("rc_cseo", args, 1)(0).vector_value ();
  return (f);
}

#define mtt_implicit(x,dx,AA,AAx,ddt,nx,open) call_mtt_implicit((x),(dx),(AA),(AAx),(ddt),(nx),(open))
ColumnVector
call_mtt_implicit (ColumnVector x,
		   ColumnVector dx,
		   Matrix AA,
		   ColumnVector AAx,
		   double ddt,
		   int nx,
		   ColumnVector open_switches)
{
  octave_value_list args, f;
  args (0) = octave_value (x);
  args (1) = octave_value (dx);
  args (2) = octave_value (AA);
  args (3) = octave_value (AAx);
  args (4) = octave_value (ddt);
  args (5) = octave_value ((double)nx);
  args (6) = octave_value (open_switches);
  f = feval ("mtt_implicit", args, 1);
  return f(0).vector_value ();
}


ColumnVector
mtt_input (ColumnVector x, ColumnVector y, const double t, ColumnVector par)
{
  octave_value_list args;
  args (0) = octave_value (x);
  args (1) = octave_value (y);
  args (2) = octave_value (t);
  args (3) = octave_value (par);
  ColumnVector f;
  f = feval ("rc_input", args, 1)(0).vector_value ();
  return (f);
}

ColumnVector
mtt_numpar (void)
{
  octave_value_list args;
  ColumnVector f;
  f = feval ("rc_numpar", args, 1)(0).vector_value ();
  return (f);
}

Octave_map
mtt_simpar (void)
{
  octave_value_list args;
  Octave_map f;
  f["first"]		= feval ("rc_simpar", args, 1)(0).map_value ()["first"];
  f["dt"]		= feval ("rc_simpar", args, 1)(0).map_value ()["dt"];
  f["last"]		= feval ("rc_simpar", args, 1)(0).map_value ()["last"];
  f["stepfactor"]     	= feval ("rc_simpar", args, 1)(0).map_value ()["stepfactor"];
  f["wmin"]		= feval ("rc_simpar", args, 1)(0).map_value ()["wmin"];
  f["wmax"]		= feval ("rc_simpar", args, 1)(0).map_value ()["wmax"];
  f["wsteps"]		= feval ("rc_simpar", args, 1)(0).map_value ()["wsteps"];
  f["input"]		= feval ("rc_simpar", args, 1)(0).map_value ()["input"];
  return (f);
}

Matrix
mtt_smxa (ColumnVector x, ColumnVector u, double t, ColumnVector par)
{
  octave_value_list args;
  args (0) = octave_value (x);
  args (1) = octave_value (u);
  args (2) = octave_value (t);
  args (3) = octave_value (par);
  Matrix f;
  f = feval ("rc_smxa", args, 1)(0).matrix_value ();
  return (f);
}

ColumnVector
mtt_smxax (ColumnVector x, ColumnVector u, double t, ColumnVector par)
{
  octave_value_list args;
  args (0) = octave_value (x);
  args (1) = octave_value (u);
  args (2) = octave_value (t);
  args (3) = octave_value (par);
  ColumnVector f;
  f = feval ("rc_smxa", args, 1)(0).vector_value ();
  return (f);
}

ColumnVector
mtt_state (ColumnVector x)
{
  octave_value_list args;
  args (0) = octave_value (x);
  ColumnVector f;
  f = feval ("rc_state", args, 1)(0).vector_value ();
  return (f);
}

ColumnVector
mtt_logic (ColumnVector x, ColumnVector u, double t, ColumnVector par)
{
  octave_value_list args;
  args (0) = octave_value (x);
  args (1) = octave_value (u);
  args (2) = octave_value (t);
  args (3) = octave_value (par);

  ColumnVector f;
  f = feval ("rc_logic", args, 1)(0).vector_value ();
  return (f);
}

void
mtt_write (double t, ColumnVector x, ColumnVector y, int nx, int ny)
{
  register int i;
  cout.precision (5);		// this should be passed in as an argument
  cout.width (12);		// as should this (instead of nx, ny)
  cout << t;
  for (i = 0; i < y.length (); i++)
    {
      cout.width (12);
      cout << '\t' << y (i);
    }
  cout.width (12);
  cout << "\t\t" << t;
  for (i = 0; i < x.length (); i++)
    {
      cout.width (12);
      cout << '\t' << x (i);
    }
  cout << endl;
}

ColumnVector nozeros (const ColumnVector v0, const double tol = 0.0)
{
  ColumnVector v (v0.length ());
  register int j;
  for (register int i = j = 0; i < v.length (); i++)
    {
      if (tol <= abs(v0 (i)))
	{
	  v (j) = v0 (i);
	  j++;
	}
    }
  return (j)
    ? v.extract (0, --j)
    : 0x0;
}


DEFUN_DLD (rc_ode2odes, args, ,
"Octave ode2odes representation of system $
rc_ode2odes (x, par, simpar)
")
{
  octave_value_list retval;

  ColumnVector	x;
  ColumnVector	par;
  Octave_map	simpar;

  int nargin = args.length ();
  switch (nargin)
    {
    case 3:
      simpar["first"]		= args (2).map_value ()["first"];
      simpar["dt"]		= args (2).map_value ()["dt"];
      simpar["last"]		= args (2).map_value ()["last"];
      simpar["stepfactor"]     	= args (2).map_value ()["stepfactor"];
      simpar["wmin"]		= args (2).map_value ()["wmin"];
      simpar["wmax"]		= args (2).map_value ()["wmax"];
      simpar["wsteps"]		= args (2).map_value ()["wsteps"];
      simpar["input"]		= args (2).map_value ()["input"];
      par    = args (1).vector_value ();
      x      = args (0).vector_value ();
      break;
    case 2:
      simpar["first"]		= mtt_simpar ()["first"];
      simpar["dt"]		= mtt_simpar ()["dt"];
      simpar["last"]		= mtt_simpar ()["last"];
      simpar["stepfactor"]     	= mtt_simpar ()["stepfactor"];
      simpar["wmin"]		= mtt_simpar ()["wmin"];
      simpar["wmax"]		= mtt_simpar ()["wmax"];
      simpar["wsteps"]		= mtt_simpar ()["wsteps"];
      simpar["input"]		= mtt_simpar ()["input"];
      par    = args (1).vector_value ();
      x      = args (0).vector_value ();
      break;
    case 1:
      simpar["first"]		= mtt_simpar ()["first"];
      simpar["dt"]		= mtt_simpar ()["dt"];
      simpar["last"]		= mtt_simpar ()["last"];
      simpar["stepfactor"]     	= mtt_simpar ()["stepfactor"];
      simpar["wmin"]		= mtt_simpar ()["wmin"];
      simpar["wmax"]		= mtt_simpar ()["wmax"];
      simpar["wsteps"]		= mtt_simpar ()["wsteps"];
      simpar["input"]		= mtt_simpar ()["input"];
      par    = mtt_numpar ();
      x      = args (0).vector_value ();
      break;
    case 0:
      simpar["first"]		= mtt_simpar ()["first"];
      simpar["dt"]		= mtt_simpar ()["dt"];
      simpar["last"]		= mtt_simpar ()["last"];
      simpar["stepfactor"]     	= mtt_simpar ()["stepfactor"];
      simpar["wmin"]		= mtt_simpar ()["wmin"];
      simpar["wmax"]		= mtt_simpar ()["wmax"];
      simpar["wsteps"]		= mtt_simpar ()["wsteps"];
      simpar["input"]		= mtt_simpar ()["input"];
      par    = mtt_numpar ();
      x      = mtt_state (par);
      break;
    default:
      usage("rc_ode2odes (x par simpar)", nargin);
      error("aborting.");
    }

  ColumnVector	dx (MTTNX);
  ColumnVector	u (MTTNU);
  ColumnVector	y (MTTNY);

  Matrix	AA (MTTNX, MTTNX);
  ColumnVector	AAx (MTTNX);

  ColumnVector	open_switches (MTTNX);

  register double t	= 0.0;

  const double	ddt	= simpar ["dt"].double_value () / simpar ["stepfactor"].double_value ();
  const int	ilast	= (int)round (simpar ["last"].double_value () / ddt);

  // cse translation
  // LSODE will need ODEFUNC

  for (register int j = 0, i = 1; i <= ilast; i++)
    {
      y	= mtt_cseo (x, u, t, par);
      u	= mtt_input (x, y, t, par);
      if (0 == j)
	{
	  // mtt_write (t, x, y, MTTNX, MTTNY);
	}
      dx = mtt_csex (x, u, t, par)(0).vector_value ();
      
      AA = mtt_smxa (x, u, ddt, par);
      AAx = mtt_smxax (x, u, ddt, par);

      open_switches = mtt_logic (x, u, t, par);
      x = mtt_implicit (x, dx, AA, AAx, ddt, 1, open_switches);
      t += ddt;
      j++;
      j = (j == (int)simpar ["stepfactor"].double_value ()) ? j : 0;
    }

  retval (0) = octave_value (y);
  retval (1) = octave_value (x);
  retval (2) = octave_value (t);
  return (retval);
}
