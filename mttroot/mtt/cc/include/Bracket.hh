/* $Id$
 * $Log$
 * Revision 1.1.4.1  2001/06/30 03:26:20  geraint
 * gcc-3.0 compatibility.
 *
 * Revision 1.1  2000/12/28 09:47:29  peterg
 * put under RCS
 *
 * Revision 1.1  2000/10/31 04:29:11  geraint
 * Initial revision
 *
 */



#include <iostream>
#include <string>


using namespace std;

class Bracket
{
public:
  friend ostream &operator<< (ostream &str, Bracket *b);
  friend string  &operator<< (string  &str, Bracket *b);
  friend string  &operator+= (string  &str, Bracket *b);
  friend string   operator+  (string  &str, Bracket *b);
  virtual int get_nesting_depth (void)		= 0;

protected:
  Bracket (char left, char right)	  	{ _l = left; _r = right; }
  ostream &open  (ostream &str)			{ this->increment_nesting (); return str << this->_l; }
  string  &open  (string  &str)			{ this->increment_nesting (); return str += this->_l; }
  ostream &close (ostream &str)			{ this->decrement_nesting (); return str << this->_r; }
  string  &close (string  &str)			{ this->decrement_nesting (); return str += this->_r; }

protected:
  virtual int increment_nesting (void)		= 0;
  virtual int decrement_nesting (void)		= 0;
  virtual ostream &display (ostream &str)	= 0;
  virtual string  &display (string  &str)	= 0;

private:
  char _l, _r;
};



class Brace : public Bracket
{
public:
  int get_nesting_depth (void)			{ return   (this->nesting_depth);}
  string indentation (int n = nesting_depth)
  {
    string s = "";
    int i;
    for (i = 0; i < n; i++)
      s += "   ";
    return s;
  }

protected:
  Brace () : Bracket ('{', '}')			{ ; }
  int increment_nesting (void)			{ return ++(this->nesting_depth); }
  int decrement_nesting (void)			{ return --(this->nesting_depth); }
  ostream &open (ostream &str)
  {
    str << endl << this->indentation ();
    this->Bracket::open (str);
    str << endl << this->indentation ();
    return str;
  }
  string &open (string &str)
  {
    str += '\n' + this->indentation ();
    this->Bracket::open (str);
    str += '\n' + this->indentation ();
    return str;
  }
  ostream &close (ostream &str)
  {
    str << endl << this->indentation (nesting_depth - 1);
    this->Bracket::close (str);
    str << endl << this->indentation ();
    return str;
  }
  string &close (string &str)
  {
    str += '\n' + this->indentation (nesting_depth - 1);
    this->Bracket::close (str);
    str += '\n' + this->indentation ();
    return str;
  }

private:
  static int nesting_depth;
};
int Brace::nesting_depth;



class Paren : public Bracket
{
public:
  int get_nesting_depth (void)			{ return   (this->nesting_depth);}

protected:
  Paren () : Bracket ('(', ')')			{ ; }
  int increment_nesting (void)			{ return ++(this->nesting_depth); }
  int decrement_nesting (void)			{ return --(this->nesting_depth); }

private:
  static int nesting_depth;
};
int Paren::nesting_depth;



class SquareBracket : public Bracket
{
public:
  int get_nesting_depth (void)			{ return   (this->nesting_depth);}

protected:
  SquareBracket () : Bracket ('[', ']')	       	{ ; }
  int increment_nesting (void)			{ return ++(this->nesting_depth); }
  int decrement_nesting (void)			{ return --(this->nesting_depth); }

private:
  static int nesting_depth;
};
int SquareBracket::nesting_depth;



class LeftBrace : public Brace
{
public:
  ostream &display (ostream &str)		{ return this->open  (str); }
  string  &display (string  &str)		{ return this->open  (str); }
};



class RightBrace : public Brace
{
public:
  ostream &display (ostream &str)		{ return this->close (str); }
  string  &display (string  &str)		{ return this->close (str); }
};



class LeftParen : public Paren
{
public:
  ostream &display (ostream &str)		{ return this->open  (str); }
  string  &display (string  &str)		{ return this->open  (str); }
};



class RightParen : public Paren
{
public:
  ostream &display (ostream &str)		{ return this->close (str); }
  string  &display (string  &str)		{ return this->close (str); }
};



class LeftSquareBracket : public SquareBracket
{
public:
  ostream &display (ostream &str)		{ return this->open  (str); }
  string  &display (string  &str)		{ return this->open  (str); }
};



class Rightbrace : public SquareBracket
{
public:
  ostream &display (ostream &str)		{ return this->close (str); }
  string  &display (string  &str)		{ return this->close (str); }
};



ostream &operator<< (ostream &str, Bracket *b)
{
  b->display (str);
  return str;
}



string  &operator<< (string  &str, Bracket *b)
{
  string s;
  b->display (s);
  str += s;
  return str;
}



string  &operator+= (string  &str, Bracket *b)
{
  b->display (str);
  return str;
}



string   operator+  (string  &str, Bracket *b)
{
  string s;
  b->display (s);
  return (str + s);
}
