
#include "mtt_Solver.hh"

Solver::Solver (sys_ae ae,
		const int npar,
		const int nu,
		const int nx,
		const int ny,
		const int nyz)
{
  _ae  = ae;
  _np  = npar; 
  _nu  = nu;
  _nx  = nx;
  _ny  = ny;
  _nyz = nyz;

  _uui = ColumnVector (_nu+_nyz);
};

ColumnVector
Solver::solve (const ColumnVector	&x,
	       const ColumnVector	&u,
	       const double		&t,
	       const ColumnVector	&par)
{
  _x = x;
  _uui.insert(u,0);
  _t = t;
  _par = par;
  _ui = ColumnVector(_nyz,1.0);
  Solve ();
  _uui.insert(_ui,_nu);
  return _uui;
}    

ColumnVector
Solver::eval (const ColumnVector &ui)
{
  _uui.insert(ui,_nu);
  return _ae (_x, _uui, _t, _par);
}
