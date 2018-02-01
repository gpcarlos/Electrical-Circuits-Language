
all: analyzer

bison: syntactic.y
	bison -d syntactic.y

flex: lexicon.l
	flex lexicon.l

analyzer: flex bison
	g++ -std=c++98 lex.yy.c syntactic.tab.c -o analyzer -lfl -lm

exe:
	cat ${FILE} | ./analyzer

clean:
	-rm -f analyzer syntactic.tab.c lex.yy.c syntactic.tab.h 2>/dev/null || true
