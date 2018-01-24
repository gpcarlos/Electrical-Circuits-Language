%{
#include "string"
#include "syntactic.tab.h"

%}

%%

[ \n\t\r]+

"switch"+[0-9]*      {//printf("Found the token SWITCH: %s\n", yytext);
                     yylval.Tstring = new std::string(yytext);
                     return(SWITCH);}
"button"+[0-9]*      {//printf("Found the token BUTTON: %s\n", yytext);
                     yylval.Tstring = new std::string(yytext);
                     return(BUTTON);}
"lamp"+[0-9]*        {//printf("Found the token LAMP: %s\n", yytext);
                     yylval.Tstring = new std::string(yytext);
                     return(LAMP);}
"bell"+[0-9]*        {//printf("Found the token BELL: %s\n", yytext);
                     yylval.Tstring = new std::string(yytext);
                     return(BELL);}
"fuse"+[0-9]*        {//printf("Found the token FUSE: %s\n", yytext);
                     yylval.Tstring = new std::string(yytext);
                     return(FUSE);}
"relay"+[0-9]*       {//printf("Found the token RELAY: %s\n", yytext);
                     yylval.Tstring = new std::string(yytext);
                     return(RELAY);}
"minute"+[0-9]*      {//printf("Found the token MINUTE: %s\n", yytext);
                     yylval.Tstring = new std::string(yytext);
                     return(MINUTE);}
"plug"+[0-9]*        {//printf("Found the token PLUG: %s\n", yytext);
                     yylval.Tstring = new std::string(yytext);
                     return(PLUG);}
"lock"+[0-9]*        {//printf("Found the token LOCK: %s\n", yytext);
                     yylval.Tstring = new std::string(yytext);
                     return(LOCK);}
"regulator"+[0-9]*   {//printf("Found the token REGULATOR: %s\n", yytext);
                     yylval.Tstring = new std::string(yytext);
                     return(REGULATOR);}
"movDetector"+[0-9]* {//printf("Found the token MOVDETECTOR: %s\n", yytext);
                     yylval.Tstring = new std::string(yytext);
                     return(MOVDETECTOR);}

"R"                  {//printf("Found the token R: %s\n", yytext);
                     yylval.Tstring = new std::string(yytext);
                     return(R);}
"S"                  {//printf("Found the token S: %s\n", yytext);
                     yylval.Tstring = new std::string(yytext);
                     return(S);}
"G"                  {//printf("Found the token G: %s\n", yytext);
                     yylval.Tstring = new std::string(yytext);
                     return(G);}

[(),]                {//printf("Found the symbol: %s\n", yytext);
                     return(*yytext);}

.                    {printf("ERROR. Invalid symbol %s\n", yytext);
                     return(INVALID);}

%%
/*
void main() {
  yylex();
}
*/


/* To compile
flex lexicon.l
cc lex.yy.c -o mylex -lfl -lm
*/
