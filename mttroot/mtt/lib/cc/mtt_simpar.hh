
#include <octave/oct.h>
#include <octave/ov-struct.h>

static ColumnVector
mtt_simpar (Octave_map simpar)
{
  static ColumnVector retval (8);

  retval (0) = simpar ["first"     ](0).double_value ();
  retval (1) = simpar ["last"      ](0).double_value ();
  retval (2) = simpar ["dt"        ](0).double_value ();
  retval (3) = simpar ["stepfactor"](0).double_value ();
  retval (4) = simpar ["wmin"      ](0).double_value ();
  retval (5) = simpar ["wmax"      ](0).double_value ();
  retval (6) = simpar ["wsteps"    ](0).double_value ();
  retval (7) = simpar ["input"     ](0).double_value ();

  return retval;
}

static Octave_map
mtt_simpar (ColumnVector simpar)
{
  static Octave_map retval;

  retval ["first"     ](0) = simpar (0);
  retval ["last"      ](0) = simpar (1);
  retval ["dt"        ](0) = simpar (2);
  retval ["stepfactor"](0) = simpar (3);
  retval ["wmin"      ](0) = simpar (4);
  retval ["wmax"      ](0) = simpar (5);
  retval ["wsteps"    ](0) = simpar (6);
  retval ["input"     ](0) = simpar (7);

  return retval;
}
