
#include <iostream>
#include <list.h>
#include <string>

    
ostream &struc2gnuplot_txt(const string sys = "sim", istream &in = cin, ostream &out = cout)
{
  typedef struct record_ record_t;
  struct record_
  {
    string       	vec;
    unsigned int	num;
    string     		cmp;
    string     	 	mod;
    unsigned int       	rpt;
  };

  list<record_t>	Lx;
  list<record_t>	Ly;

  record_t		r;


  // read data from struc.txt

  while (in >> r.vec >> r.num >> r.cmp >> r.mod >> r.rpt)
    {
      if ("state" == r.vec)
	{
	  Lx.push_back(r);
	}
      else if ("output" == r.vec)
	{
	  Ly.push_back(r);
	}
    }

  // write header

  out << "wait=-1" << endl
      << "set data style lines" << endl
      << "set xlabel \"time\"" << endl
      << "set grid" << endl
      << "set term X11" << endl
      << endl;

  // write states (X11)

  for (list<record_t>::iterator i = Lx.begin(); i != Lx.end() ; i++)
    {
      out << "plot " << "\"MTT_work/" << sys << "_odes.dat2\" using 1:" << 2 + Ly.size() + i->num
	  << " axes x1y1 title \"" << i->mod << "_" << i->cmp << ";" << endl
	  << "pause(wait);" << endl;
    }

  // write outputs (X11)

  for (list<record_t>::iterator i = Ly.begin(); i != Ly.end() ; i++)
    {
      out << "plot " << "\"MTT_work/" << sys << "_odes.dat2\" using 1:" << 1 + i->num
	  << " axes x1y1 title \"" << i->mod << "_" << i->cmp << endl
	  << "; pause(wait);" << endl;
    }

  return out;
}

#ifdef MAIN
int main(int argc, char *argv[])
{
  if (--argc)
    {
      struc2gnuplot_txt(argv[1]);
    }
  else
    {
      struc2gnuplot_txt();
    }
  return 0;
}
#endif // MAIN
