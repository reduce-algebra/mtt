
#include "mtt_Hybrd_Solver.hh"

// http://www.netlib.org/minpack/hybrd.f
// used by Octave's fsolve

MTT::Hybrd_Solver *MTT::Hybrd_Solver::static_ptr;

ColumnVector
MTT::Hybrd_Solver::f_hybrd (const ColumnVector &tryUi)
{
  MTT::Hybrd_Solver::static_ptr->_yz = MTT::Hybrd_Solver::static_ptr->eval(tryUi);
  return MTT::Hybrd_Solver::static_ptr->_yz;
}

void
MTT::Hybrd_Solver::Solve (void)
{    
  static std::fstream ferr ("MTT.Hybrd_messages", ios::out | ios::trunc | ios::app);
  int info;
  static int input_errors;
  static int user_errors;
  static int convergences;
  static int progress_errors;
  static int limit_errors;
  static int unknown_errors;
  
  NLFunc fcn(&Hybrd_Solver::f_hybrd);
  NLEqn	 eqn(Solver::_ui,fcn);
  eqn.set_tolerance(1.0e-3);
  Solver::_ui = eqn.solve(info);

  switch (info)
    {
    case 1:
      convergences++;
      break;
    case -2:
      input_errors++;
      break;
    case -1:
      user_errors++;
      break;
    case 3:
      progress_errors++;
      break;
    case 4:
      //      if (abs(eval(_ui).max()) > 1.0e-6)
      limit_errors++;
      //      else
      //	convergences++;
      break;
    default:
      unknown_errors++;
      break;
    }
  if (1 != info)
    {
      std::cerr
	<< " converge (" << convergences << ") "
	<< " limit (" << limit_errors << ")"
	<< " (max error = " << std::abs (eval(_ui).max()) << ")"
	<< " other (" << input_errors + user_errors + progress_errors + unknown_errors << ") "
	<< std::endl;
    }
  ferr << info << " ";
}
