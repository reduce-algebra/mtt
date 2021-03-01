/*  cxxsim:  creates a C++ simulation from MTT elementary system equations
 *  Copyright (C) 2000,2002  Geraint Paul Bevan
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

#include <fstream>
#include <iostream>
#include <list>
#include <map>
#include <string>

namespace cxxsim {

  class cr {
    
  public:

    cr		(std::string system_name);
    
    void read	(std::ifstream &file);
    void write	(std::ofstream &file);
   
    friend std::ifstream &operator>> (std::ifstream &file, cr &c);
    friend std::ofstream &operator<< (std::ofstream &file, cr &c);
    
  private:

    std::string			name;

    std::list<std::string>	L;
  };

  class equations {

  public:

    equations	(std::string system_name);    

    void read	(std::ifstream &file);
    void write	(std::ofstream &file);
   
    friend std::ifstream &operator>> (std::ifstream &file, equations &e);
    friend std::ofstream &operator<< (std::ofstream &file, equations &e);

  private:
    
    void descend	(std::string s);
    void parse		(void);

    std::string				name; // system name

    // list of statements collected by reader
    std::list<std::string>		statements;

    std::list<std::string>		leqn; // final expressions
    std::list<std::string>		lvar; // intermediate expressions
    std::list<std::string>		loop; // algebraic loops

    // table of final and intermediate expressions
    std::map<std::string, std::string>	meqn; // lhs, rhs mapping
    std::map<std::string, std::string>	mvar;

    // tag is symbol denoting an intermediate variable
    std::string				tag; // denotes intermediates

    // token delimiters (not ([{.`'" or alphanumeric)
    std::string				delim;
  };

  class parameter {

  public:

    parameter	(std::string system_name);

    void read	(std::ifstream &file);
    void write	(std::ofstream &file);

    friend std::ifstream &operator>> (std::ifstream &file, parameter &p);
    friend std::ofstream &operator<< (std::ofstream &file, parameter &p);

  private:

    std::string		name;

    struct record {
      std::string	variable;
      std::string	component;
    };
    
    typedef struct record record_t;
    std::list<record_t>			L;
  };

  class structure {
    
  public:

    structure		(std::string system_name);

    void read		(std::ifstream &file);
    void write		(std::ofstream &file);

    friend std::ifstream &operator>> (std::ifstream &file, structure &s);
    friend std::ofstream &operator<< (std::ofstream &file, structure &s);

  private:

    void write_declare	(std::ofstream &file);
    void write_input	(std::ofstream &file);
    void write_logic	(std::ofstream &file);
    void write_state	(std::ofstream &file);

    std::string		name;

    struct record {
      std::string	vec;	// vector: u, x, y, yz
      unsigned int	num;	// position of element in vector
      std::string	cmp;	// component
      std::string	fnm;	// full name
      unsigned int	rpt;	// number of repetitions
      std::string	cty;	// causality
    };

    typedef struct record record_t;
    std::list<record_t>			Lu;
    std::list<record_t>			Lx;
    std::list<record_t>			Ly;
    std::list<record_t>			Lyz;
    std::list<record_t>::iterator	i;    
  };

  cr::cr (std::string system_name){
    name = system_name;
  }

  void
  cr::read (std::ifstream &file){
    std::string r;
    while (file >> r){
      L.push_back(r);
    }
  }

  void
  cr::write (std::ofstream &file){
    file << "enum causality { effort, flow, state };" << std::endl
	 << "typedef enum causality causality_t;" << std::endl;
    std::list<std::string>::iterator i;
    for (i = L.begin(); i != L.end(); i++){
      if ((*i != "SS") && (*i != "ISW")){
	file << "#include <" << *i << ".hh>" << std::endl;
      }
    }
    file << std::endl;
  }

  std::ifstream &operator>> (std::ifstream &file, cr &c){
    c.read(file);
    return file;
  }
  
  std::ofstream &operator<< (std::ofstream &file, cr &c){
    c.write(file);
    return file;
  }

  equations::equations (std::string system_name){
    name = system_name;
    tag = system_name;
    delim = "~!@#$%^&*)-+=]}\\|;:,<>/?";
  };

  void
  equations::read (std::ifstream &file){
    
    char				c;
    std::string				s;
    std::string				t;

    unsigned int			i;

    //    file.unsetf(std::ios::skipws);
    file.setf(std::ios::skipws);

    // read lines from file (no max length, unlike std::getline)
    while (file >> c){
      s = "";
      while (c != ';' && file){
	if (c == '%'){
	  file.unsetf(std::ios::skipws);
	  while ((c != '\n') && file){
	    file >> c;			     // eat comment
	  }
	  file.setf(std::ios::skipws);
	} else {
	  if ((c != ' ') && (c != '\t')){    // strip whitespace
	    s += c;
	  }
	  file >> c;
	}
      }
      
      // fix vector references
      t = "MTTu(";
      while ((i = s.find(t)) < s.length()){
	s.replace(i, 5, "mttu[");
	i += s.substr(i, s.length()).find(",1)");
	s.replace(i, 3, "]");
      }
      t = "MTTx(";
      while ((i = s.find(t)) < s.length()){
	s.replace(i, 5, "mttx[");
	i += s.substr(i, s.length()).find(",1)");
	s.replace(i, 3, "]");
      }
      t = "MTTdX(";
      while ((i = s.find(t)) < s.length()){
	s.replace(i, 6, "mttdx[");
	i += s.substr(i, s.length()).find(",1)");
	s.replace(i, 3, "]");
      }
      t = "MTTy(";
      while ((i = s.find(t)) < s.length()){
	s.replace(i, 5, "mtty[");
	i += s.substr(i, s.length()).find(",1)");
	s.replace(i, 3, "]");
      }
      
      // strip newlines
      while ((i = s.find('\n')) < s.length()){
	s.replace(i, 1, "");
      }

      if ((s != "") && (s != "END")){
	// add statement to list
	statements.push_back(s);
      }
    }

    // finished reading, time to comprehend ...
    this->parse();
  }
  
  void
  equations::write (std::ofstream &file){

    std::list<std::string>::iterator	eqn;

    file << "void"					<< std::endl
	 << this->name << "_ode(const double t,"	<< std::endl
	 << "\tdouble *mttu,"				<< std::endl
	 << "\tdouble *mttx,"				<< std::endl
	 << "\tdouble *mttdx,"				<< std::endl
	 << "\tdouble *mtty)"				<< std::endl
	 << "{"						<< std::endl;
    for (eqn = leqn.begin(); eqn != leqn.end(); eqn++){
      file << *eqn << " = " << meqn[*eqn] << ";" << std::endl;
    }
    file << "} // " << this->name << "_ode"		<< std::endl;
  };

  void
  equations::descend (std::string s){

    char		c;
    unsigned int	i;
    bool		cont;

    std::list<std::string>::iterator	var;

    loop.push_back(s);

    // find algebraic loops
    for (var = loop.begin(); var != loop.end(); var++){
      if ((i = mvar[s].find(*var)) < mvar[s].length()){
	c = mvar[s].c_str()[i + var->length()];
	if (delim.find(c) < delim.length()){
	  std::cerr << std::endl
		    << "warning: algebraic loop" << std::endl
		    << '\t' << s << " = " << mvar[s].substr(0, 60);
	  if (mvar[s].length() > 60){
	    std::cerr << " ...";
	  }
	  std::cerr << std::endl << std::endl;
	  mvar[s] = s + "____loop";
	}
      }
    }

    // substitutes intermediate variables for their expansion
    do {
      cont = false;
      for (var = lvar.begin(); var != lvar.end(); var++){
	// check for token match
	while ((i = mvar[s].find(*var)) < mvar[s].length()){
	  // ensure exact match
	  c = mvar[s].c_str()[i + var->length()];
	  if (delim.find(c) < delim.length()){
	    // expand expression recursively
	    this->descend(*var);
	    // check match again, map may have changed
	    if ((i = mvar[s].find(*var)) < mvar[s].length()){
	      c = mvar[s].c_str()[i + var->length()];
	      if (delim.find(c) < delim.length()){
	    	// substitute expression
		mvar[s].replace(i, var->length(), mvar[*var]);
		// continue
		cont = true;
	      }
	    }	    
	  }
	}
      }
    } while (cont);
    loop.pop_back();
  }
  
  void
  equations::parse (void){
    
    char		c;
    unsigned int	i;

    std::string		lhs;
    std::string		rhs;
    
    std::list<std::string>::iterator	s;

    std::list<std::string>::iterator	eqn;
    std::list<std::string>::iterator	var;

    for (s = statements.begin(); s != statements.end(); s++){
      // parse statement
      if ((i = s->find(":=")) < s->length()){
	lhs = s->substr(0, i);
	rhs = s->substr(i+2, s->length());
	
	// separate intermediate and final variables
	if (s->substr(0, tag.length()) == tag){
	  // add to table of intermediate variables
	  lvar.push_back(lhs);
	  mvar[lhs] = "(" + rhs + ")";
	} else {
	  // add to table of final variables
	  leqn.push_back(lhs);
	  meqn[lhs] = rhs + ";";
	}
      } else {
	std::cerr << std::endl
		  << "warning: non-assignment -- ignoring"
		  << std::endl
		  << '\t' << *s << std::endl
		  << std::endl;
      }
    }
      
    // expand rhs of intermediate variables
    for (var = lvar.begin(); var != lvar.end(); var++){
      loop.clear();
      descend(*var);
    }
    
    // substitute expanded expressions into final equations
    for (eqn = leqn.begin(); eqn != leqn.end(); eqn++){
      for (var = lvar.begin(); var != lvar.end(); var++){
	while ((i = meqn[*eqn].find(*var)) < meqn[*eqn].length()){
	  c = meqn[*eqn].c_str()[i + var->length()];
	  if (delim.find(c) < delim.length()){
	    meqn[*eqn].replace(i, var->length(), mvar[*var]);
	  }
	}
      }
    }
  }

    std::ifstream &operator>> (std::ifstream &file, equations &e){
    e.read(file);
    return file;
  }
  
  std::ofstream &operator<< (std::ofstream &file, equations &e){
    e.write(file);
    return file;
  }

  parameter::parameter (std::string system_name){
    name = system_name;
  };

  void
  parameter::read (std::ifstream &file){
    record_t r;
    while (file >> r.variable >> r.component){
      if (r.variable.find("#") == 0){
	file.unsetf(std::ios::skipws);
	char c = '\0';
	while (c != '\n'){
	  file >> c;
	}
	file.setf(std::ios::skipws);
      } else {
	L.push_back(r);
      }
    }
  }

  void
  parameter::write (std::ofstream &file){
    std::list<record_t>::iterator i;
    std::string type;
    std::string value;
    for (i = L.begin(); i != L.end(); i++){
      if (i->variable.substr(0, 6) == "bool__"){
	type = "bool";
	value = "false";
      } else if (i->variable.substr(0, 6) == "char__"){
	type = "char";
	value = "\0";
      } else if (i->variable.substr(0, 8) == "double__"){
	type = "double";
	value = "1.0";
      } else if (i->variable.substr(0, 7) == "float__"){
	type = "float";
	value = "1.0";
      } else if (i->variable.substr(0, 5) == "int__"){
	type = "int";
	value = "1";
      } else if (i->variable.substr(0, 7) == "string__"){
	type = "std::string";
	value = "hello world!";
      } else {
	type = "double";
	value = "1.0";
      }
      file << "static " << type << "\t" << i->variable << " = " << value
	   << ";\t// " << i->component << std::endl;
    }
    file << std::endl;
  }

  std::ifstream &operator>> (std::ifstream &file, parameter &p){
    p.read(file);
    return file;
  }

  std::ofstream &operator<< (std::ofstream &file, parameter &p){
    p.write(file);
    return file;
  }

  structure::structure (std::string system_name){
    name = system_name;
  };
  
  void
  structure::read (std::ifstream &file){
    std::list<record_t> *p;
    record_t r;
    if (! file){
      std::cerr << "warning: no structure data found (empty file)" << std::endl;
    }
    while (file >> r.vec >> r.num >> r.cmp >> r.fnm >> r.rpt >> r.cty){
      if (r.vec == "input"){
	p = &(this->Lu);
      } else if (r.vec == "state"){
	p = &(this->Lx);
      } else if (r.vec == "output"){
	p = &(this->Ly);
      } else {
	p = &(this->Lyz);
      }
      p->push_back(r);
    }
  };

  void
  structure::write (std::ofstream &file){
    this->write_declare(file);
    file << std::endl;
    this->write_input(file);
    file << std::endl;
    this->write_logic(file);
    file << std::endl;
    this->write_state(file);
    file << std::endl;
  }

  void
  structure::write_declare (std::ofstream &file){
    file << "const int mttNu\t= " << this->Lu.size() + 1 << ";"	<< std::endl
	 << "const int mttNx\t= " << this->Lx.size() + 1 << ";"	<< std::endl
	 << "const int mttNy\t= " << this->Ly.size() + 1 << ";"	<< std::endl
	 << "static double mttu[mttNu];"			<< std::endl
	 << "static double mttx[mttNx];"			<< std::endl
	 << "static double mtty[mttNy];"			<< std::endl
	 << "static double mttdx[mttNx];"			<< std::endl
	 << std::endl;
  }

  void
  structure::write_input (std::ofstream &file){
    file << "void"					<< std::endl
	 << this->name << "_input(const double t,"	<< std::endl
	 << "\tdouble *mttu,"				<< std::endl
	 << "\tdouble *mttx,"				<< std::endl
	 << "\tdouble *mtty)"				<< std::endl
	 << "{"						<< std::endl;
    for (i = Lu.begin(); i != Lu.end(); i++){
      file << "\tmttu["	<< i->num << "]\t= 1.0;"
	   << "\t// "	<< i->cmp
	   << "\t("	<< i->fnm << ")"		<< std::endl;
    }
    file << "} // " << this->name << "_input"		<< std::endl;
  }

  void
  structure::write_logic (std::ofstream &file){
    file << "void"					<< std::endl
	 << this->name << "_logic(const double t,"	<< std::endl
	 << "\tdouble *mttu,"				<< std::endl
	 << "\tdouble *mttx,"				<< std::endl
	 << "\tdouble *mttdx,"				<< std::endl
	 << "\tdouble *mtty)"				<< std::endl
	 << "{"						<< std::endl;
    for (i = Lx.begin(); i != Lx.end(); i++){
      if (i->cmp == "MTT_SWITCH"){
	file << "int " << i->fnm << " = 1;"		<< std::endl
	     << "if ((" << i->fnm << " == 0)"
	     << " || ((" << i->fnm << " < 0)"
	     << " && (mttx[" << i->num << "] < 0.0))){"	<< std::endl
	     << "\tmttx[" << i->num << "]\t = 0.0;"	<< std::endl
	     << "\tmttdx[" << i->num << "]\t = 0.0;"	<< std::endl
	     << "}"					<< std::endl;
      }
    }
    file << "} // " << this->name << "_logic"		<< std::endl;
  }

  void
  structure::write_state (std::ofstream &file){
    file << "void"					<< std::endl
	 << this->name << "_state(double *mttx)"	<< std::endl
	 << "{"						<< std::endl;
    for (i = Lx.begin(); i != Lx.end(); i++){
      file << "\tmttx["	<< i->num << "]\t= 0.0;"
	   << "\t// "	<< i->cmp
	   << "\t("	<< i->fnm << ")"		<< std::endl;
    }    
    file << "} // " << this->name << "_state"		<< std::endl;      
  }

  std::ifstream &operator>> (std::ifstream &file, structure &s){
    s.read(file);
    return file;
  }

  std::ofstream &operator<< (std::ofstream &file, structure &s){
    s.write(file);
    return file;
  }

};

void
usage(const char *program){
  std::cerr << std::endl
	    << "usage: " << program << " system" << std::endl
	    << std::endl;
}

int main(int argc, char *argv[])
{
  // check usage
  if (argc != 2){
    usage(argv[0]);
    return 1;
  }
  std::string system_name = argv[1];
  
  // open files for reading and writing
  std::string cr_filename		= system_name + "_cr.txt";
  std::string parameter_filename	= system_name + "_sympar.txt";
  std::string structure_filename	= system_name + "_struc.txt";
  std::string equations_filename	= system_name + "_ese.r";
  std::string cxxsim_filename		= system_name + "_cxxsim.cc";

  std::ifstream cr_file	      (cr_filename.c_str());
  std::ifstream parameter_file(parameter_filename.c_str());
  std::ifstream structure_file(structure_filename.c_str());
  std::ifstream equations_file(equations_filename.c_str());
  std::ofstream cxxsim_file(cxxsim_filename.c_str());

  // announce transformation
  std::clog << "Creating " << cxxsim_filename << std::endl;
  
  // do transformations (abracadabra!)
  cxxsim::cr	    system_cr	    (system_name);
  cxxsim::parameter system_parameter(system_name);
  cxxsim::structure system_structure(system_name);
  cxxsim::equations system_equations(system_name);

  cr_file	 >> system_cr;
  parameter_file >> system_parameter;
  structure_file >> system_structure;
  equations_file >> system_equations;
  
  
  cxxsim_file << system_cr
	      << system_parameter
	      << system_structure 
	      << system_equations
	      << std::endl;

  cxxsim_file << std::endl
	      << "int"								<< std::endl
	      << "main(void){"							<< std::endl
	      << std::endl
	      << "  double mttdt = 0.1; // integration time step"		<< std::endl
	      << "  double mttt;"						<< std::endl
	      << "  int i;"							<< std::endl
	      << std::endl
	      << "  for (mttt = 0.0; mttt <= 10.0; mttt += mttdt){"		<< std::endl
	      << std::endl
	      << "    // get inputs and rates"					<< std::endl
	      << "    " << system_name << "_input(mttt,mttu,mttx,mtty);"	<< std::endl
	      << "    " << system_name << "_ode(mttt,mttu,mttx,mttdx,mtty);"	<< std::endl
	      << std::endl
	      << "    // integrate states (euler)"				<< std::endl
	      << "    for (i = 1; i <= mttNx; i++){"				<< std::endl
	      << "      mttx[i] += mttdx[i] * mttdt;"				<< std::endl
	      << "    }"							<< std::endl
	      << std::endl
	      << "    // overwrite switch states"				<< std::endl
	      << "    " << system_name << "_logic(mttt,mttu,mttx,mttdx,mtty);"	<< std::endl
	      << std::endl
	      << "    // write: time outputs time states"			<< std::endl
	      << "    std::cout << mttt << '\\t';"				<< std::endl
	      << "    for (i = 1; i <= mttNy; i++){"				<< std::endl
	      << "      std::cout << mtty[i] << ' ';"				<< std::endl 
	      << "    }"							<< std::endl
	      << "    std::cout << '\\t' << mttt;"				<< std::endl
	      << "    for (i = 1; i <= mttNx; i++){"				<< std::endl
	      << "      std::cout << ' ' << mttx[i];"				<< std::endl 
	      << "    }"							<< std::endl
	      << "    std::cout << std::endl;"					<< std::endl
	      << "  }"								<< std::endl
	      << "  return 0;"							<< std::endl
	      << "}"								<< std::endl;

  // close files
  cr_file.close();
  parameter_file.close();
  structure_file.close();
  equations_file.close();
  cxxsim_file.close();

  return 0;
}
