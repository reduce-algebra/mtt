

#ifndef MTT_DASSLSOLVER
#define MTT_DASSLSOLVER


#include "mtt_AlgebraicSolver.hh"
#include <octave/DASSL.h>


#ifdef  OCTAVE_DEV
#include <octave/parse.h>
#define VECTOR_VALUE column_vector_value
#else   // !OCTAVE_DEV
#include <octave/toplev.h>
#define VECTOR_VALUE vector_value
#endif  // OCTAVE_DEV


// -ae dassl


namespace MTT
{
  class Dassl_Solver : public MTT::AlgebraicSolver {
    
    // used only when called because of "-ae dassl"
    // this is not used when called by "-i dassl"
    
  public:
    
    Dassl_Solver (const int npar,
		  const int nu,
		  const int nx,
		  const int ny,
		  const int nyz)
      : MTT::AlgebraicSolver (npar, nu, nx, ny, nyz)
    {
      static_ptr = this;
    }
    
    static ColumnVector
    f_dassl (const ColumnVector &tryUi,
	     const ColumnVector &tryUidot,
	     double t, int &ires);
    
    ~Dassl_Solver (void) {};
    
  protected:
    
    void
    Solve (void);
    
  public:
    
    static Dassl_Solver *static_ptr;
    
  };
}


#endif // MTT_DASSLSOLVER
