#ifndef SIGN_HH
#define SIGN_HH

template <class T>
inline int
sign(T x)
{
  return ((x > 0) ? +1 :
	  (x < 0) ? -1 :
	  0);
}

#endif // SIGN_HH
