
#include "mtt_Solver.hh"

class Reduce_Solver : public Solver {

  // Dummy class
  // This will not be used unless the Reduce solver has failed earlier
  // in the model build process

public:

  Reduce_Solver (sys_ae ae,
		 const int npar,
		 const int nu,
		 const int nx,
		 const int ny,
		 const int nyz)
    : Solver (ae,npar,nu,nx,ny,nyz)
  { ; };
	
  void
  Solve (void);

  ColumnVector
  solve (const ColumnVector	&x,
	 const ColumnVector	&u,
	 const double		&t,
	 const ColumnVector	&par);

  ~Reduce_Solver (void) {};

};
   
