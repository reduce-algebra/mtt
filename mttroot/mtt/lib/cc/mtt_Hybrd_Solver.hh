
#ifndef MTT_HYBRDSOLVER
#define MTT_HYBRDSOLVER


#include <octave/NLEqn.h>
#include "mtt_AlgebraicSolver.hh"


namespace MTT
{
  class Hybrd_Solver : public MTT::AlgebraicSolver
  {
    // http://www.netlib.org/minpack/hybrd.f
    // used by Octave's fsolve
    
  public:

    Hybrd_Solver (const int npar,
		  const int nu,
		  const int nx,
		  const int ny,
		  const int nyz)
      : MTT::AlgebraicSolver (npar,nu,nx,ny,nyz)
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
}


#endif // MTT_HYBRDSOLVER
