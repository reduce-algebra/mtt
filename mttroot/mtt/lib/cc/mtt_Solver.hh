
#ifndef MTT_SOLVER
#define MTT_SOLVER


#include <cmath>
#include <cstdlib>
#include <iostream>

#include <octave/oct.h>


namespace MTT
{
  class Solver
  {
  public:

    Solver (const int npar,
	    const int nu,
	    const int nx,
	    const int ny,
	    const int nyz);

    virtual ~Solver (void) {};
  
  protected:
    
    ColumnVector       		_x;
    ColumnVector	       	_uui;
    double			_t;
    ColumnVector	       	_par;
    
    ColumnVector  		_ui;
    ColumnVector          	_yz;
    
    int   			_nu;
    int				_np;
    int				_nx;
    int				_ny;
    int				_nyz;
  };
}

  
#endif // MTT_SOLVER

