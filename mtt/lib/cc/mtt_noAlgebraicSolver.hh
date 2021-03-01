
#ifndef MTT_REDUCESOLVER
#define MTT_REDUCESOLVER


#include "mtt_AlgebraicSolver.hh"


namespace MTT
{
  class noAlgebraicSolver : public MTT::AlgebraicSolver
  {
    // Dummy class

  public:
    
    noAlgebraicSolver (const int npar,
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
    
    ~noAlgebraicSolver (void) {};
  };
}


#endif // MTT_REDUCESOLVER 
