
#include <octave/oct.h>
#include <octave/ov-struct.h>

static ColumnVector
mtt_simpar (Octave_map simpar)
{
  static ColumnVector retval (8);

  retval (0) = simpar ["first"     ].double_value ();
  retval (1) = simpar ["last"      ].double_value ();
  retval (2) = simpar ["dt"        ].double_value ();
  retval (3) = simpar ["stepfactor"].double_value ();
  retval (4) = simpar ["wmin"      ].double_value ();
  retval (5) = simpar ["wmax"      ].double_value ();
  retval (6) = simpar ["wsteps"    ].double_value ();
  retval (7) = simpar ["input"     ].double_value ();

  return retval;
}

static Octave_map
mtt_simpar (ColumnVector simpar)
{
  static Octave_map retval;

  retval ["first"     ] = simpar (0);
  retval ["last"      ] = simpar (1);
  retval ["dt"        ] = simpar (2);
  retval ["stepfactor"] = simpar (3);
  retval ["wmin"      ] = simpar (4);
  retval ["wmax"      ] = simpar (5);
  retval ["wsteps"    ] = simpar (6);
  retval ["input"     ] = simpar (7);

  return retval;
}
