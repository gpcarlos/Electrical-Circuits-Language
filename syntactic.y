%{

#include <iostream>
#include <string>
#include <vector>

int yylex(void);
void yyerror(const char *s);

bool error = false;
int limit = 0;

struct connector {
  bool R, S;
};

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

connectors2 : BUTTON {std::cout << *$1 << std::endl;}
              | LAMP {std::cout << *$1 << std::endl;}
              | BELL {std::cout << *$1 << std::endl;}
              | FUSE {std::cout << *$1 << std::endl;}
              | LOCK {std::cout << *$1 << std::endl;};

connectors3 : SWITCH {std::cout << *$1 << std::endl;};

connectors2or3 : PLUG {std::cout << *$1 << std::endl;};

connectors6 : REGULATOR {std::cout << *$1 << std::endl;}
              | MOVDETECTOR {std::cout << *$1 << std::endl;};

connectors18 : RELAY {std::cout << *$1 << std::endl;}
              | MINUTE {std::cout << *$1 << std::endl;};

contentT1 : connectors2 | connectors3 | connectors2or3 | connectors6 | connectors18  | R {std::cout << *$1 << std::endl;}
              | S {std::cout << *$1 << std::endl;};

contentT2 : contentT1 
            | G {std::cout << *$1 << std::endl;};

morecontentT1 : ')' | ',' contentT1 ',' contentT1 {limit+=2;} morecontentT1;
morecontentT2 : ')' | ',' contentT2 ')';

element : connectors2 '(' contentT1 ',' contentT1 ')'

          | connectors3 '(' contentT2 ',' contentT2 ',' contentT2 ')'
          | connectors2or3 '(' contentT2 ',' contentT2 morecontentT2
          | connectors6 '(' contentT1 ',' contentT1 ',' contentT1 ',' contentT1 ',' contentT1 ',' contentT1 ')'
          | connectors18 '(' contentT1 ',' contentT1 ',' contentT1 ',' contentT1 morecontentT1
          {
            limit += 4; if (limit>18) { std::cerr << "Error. Relay or Minute with " << limit << " pins" << std::endl; error = true;} else {limit = 0;}
          };


%%

void yyerror(const char* s) {
  std::cerr << "Error " << s << std::endl;
}

int main() {

  yyparse();

  if (!error) {
    std::cout << "Correct entry" << std::endl;
  }

  return 0;
}

/* To compile

bison -d syntactic.y
flex lexicon.l
g++ lex.yy.c syntactic.tab.c -o analyzer -lfl -lm
*/
