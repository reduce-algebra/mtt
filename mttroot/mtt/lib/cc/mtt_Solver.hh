
#ifndef MTT_SOLVER
#define MTT_SOLVER

#include <cmath>
#include <cstdlib>
#include <iostream>

#include <octave/oct.h>

class Solver {

protected:
  typedef ColumnVector (*sys_ae) // pointer to F${sys}_ae function
    (ColumnVector &,ColumnVector &,const double &t,ColumnVector &);

public:

  Solver (sys_ae ae,
	  const int npar,
	  const int nu,
	  const int nx,
	  const int ny,
	  const int nyz);

  ColumnVector
  solve (const ColumnVector	&x,
	 const ColumnVector	&u,
	 const double		&t,
	 const ColumnVector	&par);
  
  ColumnVector
  eval (const ColumnVector	&ui);

  virtual ~Solver (void) {};
  
protected:
  
  virtual void
  Solve (void) = 0;

protected:

  ColumnVector			_x;
  ColumnVector			_uui;
  double			_t;
  ColumnVector			_par;

  ColumnVector  		_ui;
  ColumnVector          	_yz;

  int   			_nu;
  int				_np;
  int				_nx;
  int				_ny;
  int				_nyz;
  
  sys_ae			_ae;

};

#endif // MTT_SOLVER

