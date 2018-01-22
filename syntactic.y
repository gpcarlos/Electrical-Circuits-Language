%{

#include <iostream>
#include <string>

int yylex(void);
void yyerror(const char *s);

bool error = false;
int limit = 0;

%}

%token SWITCH
%token BUTTON
%token LAMP
%token BELL
%token FUSE
%token RELAY
%token MINUTE
%token PLUG
%token LOCK
%token REGULATOR
%token MOVDETECTOR
%token R
%token S
%token G

%token INVALID

%start analyzer

%%

analyzer : circuit_to_analyze;

circuit_to_analyze : | element circuit_to_analyze ;

connectors2 : BUTTON | LAMP | BELL | FUSE | LOCK ;
connectors3 : SWITCH ;
connectors2or3 : PLUG ;
connectors6 : REGULATOR | MOVDETECTOR;
connectors18 : RELAY | MINUTE;

contentT1 : connectors2 | connectors3 | connectors2or3 | connectors6 | connectors18  | R | S;
contentT2 : contentT1 | G ;
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
