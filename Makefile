
all: analyzer doc

bison: syntactic.y
	bison -d syntactic.y

flex: lexicon.l
	flex lexicon.l

analyzer: flex bison
	g++ lex.yy.c syntactic.tab.c -o analyzer -lfl -lm

doc:
	@latexmk -pdf -xelatex -interaction=nonstopmode -shell-escape -use-make -quiet Report.tex
	@latexmk -pdf -xelatex -interaction=nonstopmode -shell-escape -use-make -quiet Guide.tex
	latexmk -c

exe:
	cat ${FILE} | ./analyzer

clean:
	-rm -f analyzer syntactic.tab.c lex.yy.c syntactic.tab.h 2>/dev/null || true
	latexmk -c
