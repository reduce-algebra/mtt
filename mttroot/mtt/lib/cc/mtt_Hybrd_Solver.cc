
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
  static std::fstream ferr ("MTT.Hybrd_messages", std::ios::out | std::ios::trunc | std::ios::app);
  int info;
  static int input_errors;
  static int user_errors;
  static int convergences;
  static int progress_errors;
  static int limit_errors;
  static int unknown_errors;
  
  NLFunc fcn(&Hybrd_Solver::f_hybrd);
  NLEqn	 eqn(Solver::_ui,fcn);
  //  eqn.set_tolerance(1.0e-20);
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
      limit_errors++;
      break;
    default:
      unknown_errors++;
      break;
    }
  std::clog.setf (std::ios::scientific);
  if (1 != info)
    {
      std::clog
	<< "\r"
	<< " time " << _t << " \t"
	<< " converge (" << convergences << ") "
	<< " limit (" << limit_errors << ")"
	<< " progress (" << progress_errors << ")"
	<< " other (" << input_errors + user_errors + unknown_errors << ") "
	<< " (max error = " << std::abs (eval(_ui).max()) << ")"
	<< std::endl;
    }
  else
    {
      std::clog
	<< "\r time " << _t << "\t max error = " << std::abs (eval(_ui).max());
    }
  ferr << info << " ";
}
