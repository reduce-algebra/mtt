
#include "mtt_Hybrd_Solver.hh"

// http://www.netlib.org/minpack/hybrd.f
// used by Octave's fsolve
  
Hybrd_Solver *Hybrd_Solver::static_ptr;

ColumnVector
Hybrd_Solver::f_hybrd (const ColumnVector &tryUi)
{
  Hybrd_Solver::static_ptr->_yz = Hybrd_Solver::static_ptr->eval(tryUi);
  return Hybrd_Solver::static_ptr->_yz;
}

void
Hybrd_Solver::Solve (void)
{    
  int info;
  static int input_errors;
  static int user_errors;
  static int convergences;
  static int progress_errors;
  static int limit_errors;
  static int unknown_errors;
  
  NLFunc fcn(&Hybrd_Solver::f_hybrd);
  NLEqn	 eqn(Solver::_ui,fcn);
  eqn.set_tolerance(0.000001);
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
      std::cerr << "input (" << input_errors << ") "
		<< "  user (" << user_errors << ") "
		<< "  converge (" << convergences << ") "
		<< "  progress (" << progress_errors << ") "
		<< "  limit (" << limit_errors << ")"
		<< "  unknown (" << unknown_errors << ")"
		<< "  (max error = " << std::abs(eval(_ui).max()) << ")" << std::endl;
    }
}

