
#include "mtt_AlgebraicSolver.hh"

ColumnVector
MTT::AlgebraicSolver::solve (const ColumnVector	&x,
			     const ColumnVector	&u,
			     const double	&t,
			     const ColumnVector	&par)
{
  if (_nyz > 0)
    {
      _x = x;
      _uui.insert(u,0);
      _t = t;
      _par = par;
      _ui = ColumnVector(_nyz,0.0);
      Solve();
      _uui.insert(_ui,_nu);
    }
  else
    {
      _uui = u;
    }
  return _uui;
}

ColumnVector
MTT::AlgebraicSolver::eval (const ColumnVector	&ui)
{
  if (_nyz > 0)
    _uui.insert(ui,_nu);
  return mtt_ae(_x,_uui,_t,_par);
}
