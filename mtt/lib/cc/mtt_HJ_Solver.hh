
#ifndef MTT_HJSOLVER
#define MTT_HJSOLVER


#include "mtt_AlgebraicSolver.hh"


namespace MTT
{
  class HJ_Solver : public MTT::AlgebraicSolver
  {
    // http://www.netlib.org/opt/hooke.c
    // Hooke and Jeeves solution

  public:
  
    HJ_Solver (const int npar,
	       const int nu,
	       const int nx,
	       const int ny,
	       const int nyz)
      : MTT::AlgebraicSolver (npar,nu,nx,ny,nyz)
    {
      static_ptr = this;
      VARS = nyz;
    }
  
    static double
    f (double tryUi[], int nyz);
  
    ~HJ_Solver (void) {};

  protected:

    void
    Solve (void);

    double
    best_nearby (double    	delta[],
		 double   	point[],
		 double   	prevbest,
		 int      	nvars);
  
    int
    hooke (int		nvars,			  // MTTNYZ
	   double	startpt[],		  // user's initial guess
	   double	endpt[],		  // result
	   double	rho		= 0.05,	  // geometric shrink factor
	   double	epsilon		= 1e-3,	  // end value stepsize
	   int		itermax		= 5000);  // max # iterations 

  private:

    int VARS;
    
  public:

    static HJ_Solver *static_ptr;
    
  };
}


#endif // MTT_HJSOLVER
