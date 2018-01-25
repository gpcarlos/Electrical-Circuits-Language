%{

#include <iostream>
#include <string>
#include <vector>

int yylex(void);
void yyerror(const char *s);

bool error = false;
int limit = 0;

struct connector {
  std::vector<std::string> ctr;
  std::string R, S;
  connector(){R="nope"; S="nope";}
};

connector aux;
std::vector<connector> circuit;

%}

%union {
  std::string * Tstring;
}

%token <Tstring> SWITCH
%token <Tstring> BUTTON
%token <Tstring> LAMP
%token <Tstring> BELL
%token <Tstring> FUSE
%token <Tstring> RELAY
%token <Tstring> MINUTE
%token <Tstring> PLUG
%token <Tstring> LOCK
%token <Tstring> REGULATOR
%token <Tstring> MOVDETECTOR
%token <Tstring> R
%token <Tstring> S
%token <Tstring> G

%token INVALID

%start analyzer

%%

analyzer : circuit_to_analyze;

circuit_to_analyze : | element circuit_to_analyze ;

connectors2 : BUTTON
              {/*std::cout << *$1 << std::endl;*/ aux.ctr.push_back(*$1);}
              | LAMP
              {/*std::cout << *$1 << std::endl;*/ aux.ctr.push_back(*$1);}
              | BELL
              {/*std::cout << *$1 << std::endl;*/ aux.ctr.push_back(*$1);}
              | FUSE
              {/*std::cout << *$1 << std::endl;*/ aux.ctr.push_back(*$1);}
              | LOCK
              {/*std::cout << *$1 << std::endl;*/ aux.ctr.push_back(*$1);};

connectors3 : SWITCH
              {/*std::cout << *$1 << std::endl;*/ aux.ctr.push_back(*$1);};

connectors2or3 : PLUG
              {/*std::cout << *$1 << std::endl;*/ aux.ctr.push_back(*$1);};

connectors6 : REGULATOR
              {/*std::cout << *$1 << std::endl;*/ aux.ctr.push_back(*$1);}
              | MOVDETECTOR
              {/*std::cout << *$1 << std::endl;*/ aux.ctr.push_back(*$1);};

connectors18 : RELAY
              {/*std::cout << *$1 << std::endl;*/ aux.ctr.push_back(*$1);}
              | MINUTE
              {/*std::cout << *$1 << std::endl;*/ aux.ctr.push_back(*$1);};

contentT1 : connectors2 | connectors3 | connectors2or3 | connectors6 | connectors18  | R
              {/*std::cout << *$1 << std::endl;*/ aux.ctr.push_back(*$1); aux.R=*$1;}
              | S
              {/*std::cout << *$1 << std::endl;*/ aux.ctr.push_back(*$1); aux.S=*$1;};

contentT2 : contentT1 | G {/*std::cout << *$1 << std::endl;*/};

morecontentT1 : ')' | ',' contentT1 ',' contentT1 {limit+=2;} morecontentT1;
morecontentT2 : ')' | ',' contentT2 ')';

element : connectors2 '(' contentT1 ',' contentT1 ')'
          {circuit.push_back(aux); aux=connector();} /*Aux reset*/

          | connectors3 '(' contentT2 ',' contentT2 ',' contentT2 ')'
          {circuit.push_back(aux); aux=connector();}

          | connectors2or3 '(' contentT2 ',' contentT2 morecontentT2
          {circuit.push_back(aux); aux=connector();}

          | connectors6 '(' contentT1 ',' contentT1 ',' contentT1 ',' contentT1 ',' contentT1 ',' contentT1 ')'
          {circuit.push_back(aux); aux=connector();}

          | connectors18 '(' contentT1 ',' contentT1 ',' contentT1 ',' contentT1 morecontentT1
          {
            circuit.push_back(aux); aux=connector();
            limit += 4; if (limit>18) { std::cerr << "Error. Relay or Minute with " << limit << " pins" << std::endl; error = true;} else {limit = 0;}
          };


%%

void showCircuit () {

  std::vector<connector>::iterator it = circuit.begin();

  while (it!= circuit.end()) {
    std::vector<std::string>::iterator it2 = it->ctr.begin();
    while (it2!=it->ctr.end()){
      std::cout << *it2 << " ";
      ++it2;
    }
    std::cout << " " << it->R << " " << it->S <<std::endl;
    ++it;
  }

}

void yyerror(const char* s) {
  std::cerr << "Error " << s << std::endl;
}

int main() {

  yyparse();

  if (!error) {
    std::cout << "Correct entry" << std::endl;
  }

  showCircuit();

  return 0;
}

/* To compile

bison -d syntactic.y
flex lexicon.l
g++ lex.yy.c syntactic.tab.c -o analyzer -lfl -lm
*/
