
#include "mtt_Solver.hh"
#include <octave/NLEqn.h>

class Hybrd_Solver : public Solver {

  // http://www.netlib.org/minpack/hybrd.f
  // used by Octave's fsolve
  
public:

  Hybrd_Solver (sys_ae ae,
		const int npar,
		const int nu,
		const int nx,
		const int ny,
		const int nyz)
  : Solver (ae,npar,nu,nx,ny,nyz)
  {
    static_ptr = this;
  }

  static ColumnVector
  f_hybrd (const ColumnVector &tryUi);

  ~Hybrd_Solver (void) {};

protected:

  void
  Solve (void);

public:

  static Hybrd_Solver *static_ptr;

};

