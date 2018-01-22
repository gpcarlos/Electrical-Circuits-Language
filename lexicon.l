%{
#include <stdio.h>
#include <stdlib.h>

#include "syntactic.tab.h"

%}

%%

[ \n\t\r]+

"switch"+[0-9]*      {printf("Found the token SWITCH: %s\n", yytext);}
                     return(SWITCH);
"button"+[0-9]*      {printf("Found the token BUTTON: %s\n", yytext);}
                     return(BUTTON);
"lamp"+[0-9]*        {printf("Found the token LAMP: %s\n", yytext);}
                     return(LAMP);
"bell"+[0-9]*        {printf("Found the token BELL: %s\n", yytext);}
                     return(BELL);
"fuse"+[0-9]*        {printf("Found the token FUSE: %s\n", yytext);}
                     return(FUSE);
"relay"+[0-9]*       {printf("Found the token RELAY: %s\n", yytext);}
                     return(RELAY);
"minute"+[0-9]*      {printf("Found the token MINUTE: %s\n", yytext);}
                     return(MINUTE);
"plug"+[0-9]*        {printf("Found the token PLUG: %s\n", yytext);}
                     return(PLUG);
"lock"+[0-9]*        {printf("Found the token LOCK: %s\n", yytext);}
                     return(LOCK);
"regulator"+[0-9]*   {printf("Found the token REGULATOR: %s\n", yytext);}
                     return(REGULATOR);
"movDetector"+[0-9]* {printf("Found the token MOVDETECTOR: %s\n", yytext);}
                     return(MOVDETECTOR);

"R"                  {printf("Found the token R: %s\n", yytext);}
                     return(R);
"S"                  {printf("Found the token S: %s\n", yytext);}
                     return(S);
"G"                  {printf("Found the token G: %s\n", yytext);}
                     return(G);

[(),]                {printf("Found: %s\n", yytext);}
                     return(yytext);

.                    {printf("Found the token INVALID: %s\n", yytext);}
                     return(INVALID);

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
