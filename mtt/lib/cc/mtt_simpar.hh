
#include <octave/oct.h>
#include <octave/oct-map.h>

static ColumnVector
mtt_simpar (Octave_map simpar)
{
  static ColumnVector retval (8);

  retval (0) = simpar.contents (simpar.seek ("first"     ))(0).double_value ();
  retval (1) = simpar.contents (simpar.seek ("last"      ))(0).double_value ();
  retval (2) = simpar.contents (simpar.seek ("dt"        ))(0).double_value ();
  retval (3) = simpar.contents (simpar.seek ("stepfactor"))(0).double_value ();
  retval (4) = simpar.contents (simpar.seek ("wmin"      ))(0).double_value ();
  retval (5) = simpar.contents (simpar.seek ("wmax"      ))(0).double_value ();
  retval (6) = simpar.contents (simpar.seek ("wsteps"    ))(0).double_value ();
  retval (7) = simpar.contents (simpar.seek ("input"     ))(0).double_value ();

  return retval;
}

static Octave_map
mtt_simpar (ColumnVector simpar)
{
  static Octave_map retval;

  retval.assign ("first"     , simpar (0));
  retval.assign ("last"      , simpar (1));
  retval.assign ("dt"        , simpar (2));
  retval.assign ("stepfactor", simpar (3));
  retval.assign ("wmin"      , simpar (4));
  retval.assign ("wmax"      , simpar (5));
  retval.assign ("wsteps"    , simpar (6));
  retval.assign ("input"     , simpar (7));

  return retval;
}
