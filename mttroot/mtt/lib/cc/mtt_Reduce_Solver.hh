
#ifndef MTT_REDUCESOLVER
#define MTT_REDUCESOLVER


#include "mtt_AlgebraicSolver.hh"


namespace MTT
{
  class Reduce_Solver : public MTT::AlgebraicSolver
  {
    // Dummy class
    // This will not be used unless the Reduce solver has failed earlier
    // in the model build process

  public:
    
    Reduce_Solver (const int npar,
		   const int nu,
		   const int nx,
		   const int ny,
		   const int nyz)
      : AlgebraicSolver (npar,nu,nx,ny,nyz)
    {;}
	
    void
    Solve (void);
    
    ColumnVector
    solve (const ColumnVector	&x,
	   const ColumnVector	&u,
	   const double		&t,
	   const ColumnVector	&par);
    
    ~Reduce_Solver (void) {};
  };
}


#endif // MTT_REDUCESOLVER 
