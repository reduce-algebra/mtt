
#include "mtt_Reduce_Solver.hh"


void
Reduce_Solver::Solve (void)
{
  //  std::cerr << "Error:"
  //	    << " Symbolic solution of equations failed during model build" << std::endl
  //	    << "       Try using one of the other algebraic solution methods" << std::endl;
}

ColumnVector
Reduce_Solver::solve (const ColumnVector	&x,
		      const ColumnVector	&u,
		      const double		&t,
		      const ColumnVector	&par)
{
  return u;
}
