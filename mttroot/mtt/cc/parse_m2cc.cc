/* $Id$
 * $Log$
 * Revision 1.1  2000/10/31 04:29:50  geraint
 * Initial revision
 *
 */



#include <iostream>
#include <map>
#include <stack>
#include <string>



/*
 * Bracket.hh deals with nesting levels of parenthesis
 * just add Bracket pointer to string / stream
 */
#include "Bracket.hh"



/*
 * use lbrace, etc. in expressions to automate nesting calculations
 */
LeftBrace	*lbrace = new LeftBrace;
RightBrace	*rbrace = new RightBrace;

LeftParen	*lparen = new LeftParen;
RightParen	*rparen = new RightParen;



/*
 * use brace nesting depth to determine indentation
 */
string indent (void) { return lbrace->indentation (); }



/*
 * map contains keyword to look for and function to call when found
 */
map <string, void (*)(void)> keyword;




/*
 * stack records current nest type
 * so that "end" can be handled correctly
 */
enum nest_type
{
  null,
  if_statement,
  switch_statement,
  while_statement
};

stack <enum nest_type> current_nest;



/*
 * assuming cin has '(' as next character
 * find the matching ')' and return the string contained within
 */
string get_test (void)
{
  const int entry_nesting = lparen->get_nesting_depth ();
  char c;
  string buf = "";
  cin.setf (ios::skipws);
  cin >> c;
  if ('(' != c)
    {
      cerr << "Sorry, test must be enclosed in ( )" << endl;
      cerr << "current character is " << c << endl;
      /*
       * replace this with a call to get_expression maybe?
       */
      exit (-1);
    }
  else
    {
      buf += lparen;
    }
  cin.unsetf (ios::skipws);
  while (entry_nesting != lparen->get_nesting_depth ()) {
    cin >> c;
    switch (c)
      {	
      case '(':
	buf += lparen;
	break;
      case ')':
	buf += rparen;
	break;
      case EOF:
	cerr << "Oops! EOF reached" << endl;
	exit (-1);
      default:
	buf += c;
	break;
      }
  }
  return buf;
}



/*
 * functions to be called upon detection of keyword
 */
void got_if (void)
{
  current_nest.push (if_statement);
  cout << "if ";
  cout << get_test ();
  cout << lbrace;
}

void got_else (void)
{
  cout << rbrace;
  cout << "else";
  cout << lbrace;
}

void got_elseif (void)
{
  cout << rbrace;
  got_if ();
} 

void got_switch (void)
{
  current_nest.push (switch_statement);
  cout << "switch ";
  cout << get_test ();
  cout << lbrace;
  /*
   * open a second brace so that each "case" can be enclosed
   */
  cout << lbrace;
}

void got_case (void)
{
  cout << rbrace;
  cout << "case ";
  cout << get_test ();
  cout << ':';
  cout << lbrace;
}

void got_otherwise (void)
{
  cout << rbrace;
  cout << "default:";
  cout << lbrace;
}

void got_while (void)
{
  current_nest.push (while_statement);
  cout << "while ";
  cout << get_test ();
  cout << lbrace;
}

void got_end (void)
{
  enum nest_type n = current_nest.top ();
  switch (n)
    {
    case if_statement:
    case while_statement:
      cout << rbrace;      
      break;
    case switch_statement:
      cout << rbrace
	   << rbrace;
      break;
    default:
      cerr << "Oops! Unmatched end ... aborting" << endl;
      exit (-1);
      break;
    }
  current_nest.pop ();
}

void got_comment (void)
{
  /*
   * get remainder of line in case there are any commented keywords
   */
  char c;
  cout << " // ";
  cin >> c;
  while (c != '\n' && c != EOF)
    {
      cout << c;
      cin >> c;
    }
  cout << endl
       << indent () << ';' << endl
       << indent ();
}
  


/*
 * map contains keyword to look for and functions to call when found
 * functions must be of the form "void f (void) {...;}"
 * new structures should also be added to enum nest_type
 */
void set_keyword (void)
{
  // if
  keyword ["if"]		= got_if;
  keyword ["else"]		= got_else;
  keyword ["elseif"]		= got_elseif;
  keyword ["endif"]		= got_end;

  // switch
  keyword ["switch"]		= got_switch;
  keyword ["case"]		= got_case;
  keyword ["otherwise"] 	= got_otherwise;
  keyword ["endswitch"] 	= got_end;

  // while
  keyword ["while"]		= got_while;
  keyword ["endwhile"]		= got_end;

  // general
  keyword ["end"]		= got_end;

  /*
   * this won't work inside a string
   * or if there is no space around the delimiter
   */
  keyword ["#"]			= got_comment;
  keyword ["//"]		= got_comment;
  
/*
 * unimplemented keywords
 *
 keyword ["for"]		= got_for;
 keyword ["endfor"]		= got_end;
 keyword ["break"]		= got_break;
 keyword ["continue"]		= got_continue;
*/
}



/* read in one character at a time looking for tokens (delimited by whitespace)
 * if the token is a keyword, call the appropriate function
 */
int main (void)
{
  set_keyword ();
  string buf = "";
  char c;
  cin.unsetf (ios::skipws);
  while (cin >> c)
    {
      switch (c)
	{
	case EOF:
	  return 0;
	case ' ':
	case '\t':
	  if (keyword [buf])
	    {
	      keyword [buf]();
	    }
	  else
	    {
	      if (! lbrace->get_nesting_depth ())
		{
		  buf += c;
		}
	      cout << buf;
	    }
	  buf = "";
	  break;
	case '\n':
	  if (keyword [buf])
	    {
	      /*
	       * keyword found, call function
	       */
	      keyword [buf] ();
	    }
	  else
	    {
	      cout << buf
		/*
		 * keep newline in case this line has an EOL-comment
		 */
		   << endl
		/*
		 * EOL is end-of-statement in Octave, add ;
		 */
		   << indent () << ';' << endl
		   << indent ();
	    }
	  buf = "";
	  break;
	default:
	  buf += c;
	}
      if (lbrace->get_nesting_depth ())
	{
	  cout.setf (ios::skipws);
	}
      else
	{
	  cout.unsetf (ios::skipws);
	}
    }
  return 0;
}


