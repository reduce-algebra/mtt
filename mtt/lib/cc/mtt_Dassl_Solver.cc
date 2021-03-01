
#include "mtt_Dassl_Solver.hh"


// used by "-ae dassl" NOT "-i dassl"


MTT::Dassl_Solver *MTT::Dassl_Solver::static_ptr;

ColumnVector
MTT::Dassl_Solver::f_dassl (const ColumnVector &tryUi,
			    const ColumnVector &tryUidot,
			    double t, int &ires)
{
  static MTT::Dassl_Solver *p = MTT::Dassl_Solver::static_ptr;

  ColumnVector residual = p->eval(tryUi);
  ColumnVector uidoterr = (tryUi - p->_ui) - tryUidot;  
  p->_yz = residual + uidoterr;
  return p->_yz;
}

void
MTT::Dassl_Solver::Solve (void)
{
  const double t0 = 0.0;
  const double t1 = 1.0;
  DAEFunc fcn(&MTT::Dassl_Solver::f_dassl);
  DASSL   eqn(AlgebraicSolver::_ui,t0,fcn);
  AlgebraicSolver::_ui = eqn.do_integrate (t1);
}
