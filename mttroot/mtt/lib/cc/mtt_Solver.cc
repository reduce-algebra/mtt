
#include "mtt_Solver.hh"

MTT::Solver::Solver (const int npar,
		     const int nu,
		     const int nx,
		     const int ny,
		     const int nyz)
{
  _np  = npar; 
  _nu  = nu;
  _nx  = nx;
  _ny  = ny;
  _nyz = nyz;
  _ui  = ColumnVector (_nyz,0.0);
  _uui = ColumnVector (_nu+_nyz);
};
