
#include "mtt_noAlgebraicSolver.hh"

void
MTT::noAlgebraicSolver::Solve (void)
{
  ;
}

ColumnVector
MTT::noAlgebraicSolver::solve (const ColumnVector	&x,
			       const ColumnVector	&u,
			       const double		&t,
			       const ColumnVector	&par)
{
  return u;
}
