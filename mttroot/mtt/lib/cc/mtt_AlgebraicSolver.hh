
#ifndef MTT_ALGEBRAICSOLVER
#define MTT_ALGEBRAICSOLVER


#include "mtt_Solver.hh"


namespace MTT
{
  class AlgebraicSolver : public MTT::Solver
  {
  public:

    AlgebraicSolver (const int npar,
		     const int nu,
		     const int nx,
		     const int ny,
		     const int nyz)
      : MTT::Solver (npar,nu,nx,ny,nyz)
    {;}

    ColumnVector
    solve (const ColumnVector	&x,
	   const ColumnVector	&u,
	   const double		&t,
	   const ColumnVector	&par);

    ColumnVector
    eval (const ColumnVector	&ui);

    virtual ~AlgebraicSolver (void) {};

  protected:

    virtual void
    Solve (void) = 0;
  };
}


extern ColumnVector
mtt_ae(ColumnVector	&x,
       ColumnVector	&u,
       const double	&t,
       ColumnVector	&par);


#endif // MTT_ALGEBRAICSOLVER
