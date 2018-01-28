%{

#include <iostream>
#include <string>
#include <vector>

int yylex(void);
void yyerror(const char *s);

bool error = false, isAplug = false, has3 = false;
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
%token <Tstring> SENSOR
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

connectors2 : BUTTON {aux.ctr.push_back(*$1);}
              | LAMP {aux.ctr.push_back(*$1);}
              | SENSOR {aux.ctr.push_back(*$1);}
              | BELL {aux.ctr.push_back(*$1);}
              | FUSE {aux.ctr.push_back(*$1);}
              | LOCK {aux.ctr.push_back(*$1);};

connectors2or3 : PLUG {aux.ctr.push_back(*$1); isAplug = true;}
                 | SWITCH {aux.ctr.push_back(*$1); isAplug = false;};

connectors6 : REGULATOR {aux.ctr.push_back(*$1);}
              | MOVDETECTOR {aux.ctr.push_back(*$1);};

connectors18 : RELAY {aux.ctr.push_back(*$1);}
              | MINUTE {aux.ctr.push_back(*$1);};

contentT1 : connectors2 | connectors2or3 | connectors6 | connectors18  | R {aux.ctr.push_back(*$1); aux.R=*$1;}
              | S {aux.ctr.push_back(*$1); aux.S=*$1;}
              | INVALID {error=true;};

contentT2 : contentT1 | G {aux.ctr.push_back(*$1);};

morecontentT1 :  contentT1 ',' contentT1 ')' {limit+=2;}
                | contentT1 ',' contentT1  ',' morecontentT1 {limit+=2;}
                | contentT1 ')'
                { limit+=1;
                  std::string typeError = aux.ctr[0]+" has an odd number of pins";
                  yyerror(typeError.c_str());};
morecontentT2 : ')' {has3=false;}| ',' contentT2 ')' {has3=true;};

element : connectors2 '(' contentT1 ',' contentT1 ')'
          {circuit.push_back(aux); aux=connector();}

          | connectors2or3 '(' contentT2 ',' contentT2 morecontentT2
          {circuit.push_back(aux); aux=connector();
           if (isAplug&&has3) {
             if (aux.ctr[3]!="G") {
               std::string typeError = aux.ctr[0]+" is not connected to G";
               yyerror(typeError.c_str());
             }
           }
          }

          | connectors6 '(' contentT1 ',' contentT1 ',' contentT1 ',' contentT1 ',' contentT1 ',' contentT1 ')'
          {circuit.push_back(aux); aux=connector();}

          | connectors18 '(' morecontentT1
          {circuit.push_back(aux); aux=connector();
           if (limit>18) {
             std::string typeError = aux.ctr[0]+" has more than 18 pins";
             yyerror(typeError.c_str());
           } else {
             if (limit<4) {
               std::string typeError = aux.ctr[0]+" has less than 4 pins";
               yyerror(typeError.c_str());
             } else {limit = 0;}
           }
          };


%%

void checkDuplicates(){
  std::vector<connector>::iterator element1 = circuit.begin();
  while(element1 != circuit.end()){
    std::vector<connector>::iterator element2 = element1+1;
    while(element2!=circuit.end()){
      if(element1->ctr[0] == element2->ctr[0]){
        std::string typeError = element1->ctr[0]+ " is duplicated";
        yyerror(typeError.c_str());
      }
      ++element2;
    }
    ++element1;
  }
}



bool lookforCable (std::string cable, std::string elem) {
  if (cable == "R") {
    std::vector<connector>::iterator it = circuit.begin();
    bool found = false;
    while (it!= circuit.end() && !found ) {
      if (it->ctr[0]==elem) {
        found = true;
        if (it->ctr[1]=="R") { return true;}
        else { return lookforCable("R",it->ctr[1]);}
      }
      ++it;
    }
    if (!found) {
      return false;
    }
  } else { // cable == "S"
    std::vector<connector>::iterator it = circuit.begin();
    bool found = false;
    while (it!= circuit.end() && !found ) {
      if (it->ctr[0]==elem) {
        found = true;
        if (it->ctr[2]=="S") { return true;}
        else { return lookforCable("S",it->ctr[2]);}
      }
      ++it;
    }
    if (!found) {
      return false;
    }
  }
}

void checkCircuit () {
  std::vector<connector>::iterator it = circuit.begin();

  while (it!= circuit.end()) {
      if (it->R=="nope") {
        if (lookforCable("R",it->ctr[1])) {
          it->R="R";
        } else {
          std::string typeError = it->ctr[0]+" is not connected to R";
          yyerror(typeError.c_str());
        }
      }
      if (it->S=="nope") {
        if (lookforCable("S",it->ctr[2])) {
          it->S="S";
        } else {
          std::string typeError = it->ctr[0]+" is not connected to S";
          yyerror(typeError.c_str());
        }
      }
    ++it;
  }
}

void showCircuit () {
  std::vector<connector>::iterator it = circuit.begin();

  while (it!= circuit.end()) {
    std::vector<std::string>::iterator it2 = it->ctr.begin();
    while (it2!=it->ctr.end()){
      std::cout << *it2 << " ";
      ++it2;
    }
    std::cout << "\t Connected to " << it->R << " and " << it->S <<std::endl;
    ++it;
  }
}

void yyerror(const char* s) {
  std::cerr << "Error " << s << std::endl;
  error = true;
}

int main() {

  yyparse();
  checkDuplicates();
  if(!error){
    checkCircuit();
    if (!error) {
      std::cout << "Correct entry" << std::endl;
      std::cout << "This is the circuit: " << std::endl;
      std::cout << "-----------------------------------------\n";
      showCircuit();
      std::cout << "-----------------------------------------\n";
    }
  }

  return 0;
}

/* To compile

bison -d syntactic.y
flex lexicon.l
g++ lex.yy.c syntactic.tab.c -o analyzer -lfl -lm
*/
