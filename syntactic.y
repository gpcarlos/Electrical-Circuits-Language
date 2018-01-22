%{
#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <vector>
#include <string>

using namespace std;

int yylex(void);
void yyerror(const char *s);

struct connector {
  bool R;
  bool S;
  connector (bool r, bool s){R=r;S=s;}
};

std::vector<connector> circuit;

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
morecontentT1 : ')' | ',' contentT1 ',' contentT1 morecontentT1;
morecontentT2 : ')' | ',' contentT2 ')';

element : connectors2 '(' contentT1 ',' contentT1 ')'
          {
            //
          }
          | connectors3 '(' contentT2 ',' contentT2 ','    contentT2 ')'
          {
            //
          }
          | connectors2or3 '(' contentT2 ',' contentT2 morecontentT2
          {
            //
          }
          | connectors6 '(' contentT1 ',' contentT1 ',' contentT1 ',' contentT1 ',' contentT1 ',' contentT1 ')'
          {
            //
          }
          |
          connectors18 '(' contentT1 ',' contentT1 ',' contentT1 ',' contentT1 morecontentT1
          {
            //
          };


%%

bool checkCircuit(){

}

void yyerror(const char* s) {
  printf("Error %s",s);
}

int main() {

  yyparse();

  for (int i=0; circuit.size() ; i++) {
    std::cout << circuit[i].R << std::endl;
  }
  printf("Correct entry.\n");

  return 0;
}

/* To compile

bison -d syntactic.y
flex lexicon.l
g++ lex.yy.c syntactic.tab.c -o analyzer -lfl -lm
*/
