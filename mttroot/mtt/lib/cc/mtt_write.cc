#include <octave/oct.h>
#include <octave/variables.h>

#ifdef STANDALONE
static Matrix MTT_data;
#endif

DEFUN_DLD (mtt_write, args, ,
	   "append current data to output")
{
  const double		t	= args(0).double_value ();
#ifdef OCTAVE_DEV
  const ColumnVector	x	= args(1).column_vector_value ();
  const ColumnVector	y	= args(2).column_vector_value ();
#else
  const ColumnVector	x	= args(1).vvector_value ();
  const ColumnVector	y	= args(2).vector_value ();
#endif

  const int		nx	= x.length ();
  const int		ny	= y.length ();


  ColumnVector Output (2+nx+ny, 0.0);
  
  Output (0) = Output (1+nx) = t;
  Output.insert (x.transpose (), 1);
  Output.insert (y.transpose (), 2+nx);

  Matrix data;

  if (0.0 == t)
    {
      data = static_cast<Matrix> (Output.transpose ());
    }
  else
    {
#ifdef STANDALONE
      data = MTT_data.transpose ();
#else
      data = get_global_value ("MTT_data").matrix_value ().transpose ();
#endif
      data = data.append (Output);
    }
  data = data.transpose ();
#ifdef STANDALONE
  MTT_data = data;
  cout << Output.transpose () << endl;
#else
  set_global_value ("MTT_data", data);
#endif
  return data;
}

