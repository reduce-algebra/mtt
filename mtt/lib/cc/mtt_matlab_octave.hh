
#ifndef MTT_MATLAB_OCTAVE_HH
#define MTT_MATLAB_OCTAVE_HH

#include <octave/oct.h>
#include <mex.h>

// conversions from Matlab mxArray* to Octave data types

extern Matrix
mtt_Matrix (const mxArray *m);

extern ColumnVector
mtt_ColumnVector (const mxArray *m);

extern const double
mtt_double (const mxArray *m);


// conversions from Octave data types to Matlab mxArray*

extern mxArray *
mtt_mxArray (const Matrix &o);

extern mxArray *
mtt_mxArray (const ColumnVector &o);

#endif // MTT_MATLAB_OCTAVE_HH
