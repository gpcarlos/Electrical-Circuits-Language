# Electrical-Circuits-Language

Practice of the subject Automata Theory and Formal Language. University of Cádiz.



## Prerequisites
- Flex
- Bison
- GCC / G++
- LaTeX builder

## Compilation
  For an easy compilation, you just need the provided Makefile, so:


  ```bash
  make all
  ```

  If you want to compile every file step by step:

  ```bash
  make flex
  make bison
  make analyzer
  ```

  But, if you prefer the "hard'' way:

  ```bash
  flex lexicon.l
  bison -d syntactic.y
  g++ lex.yy.c syntactic.tab.c -o analyzer -lfl -lm
  ```
## Execution
  Finally, if you want to execute the analyzer, just type:

  ```bash
  make exe FILE="CircuitName.circuit"
  ```

  The other option is:

  ```bash
  cat CircuitName.circuit | ./analyzer
  ```

## Authors

* **Juan Francisco Cabrera Sánchez** - *Github profile* - [JF95](https://github.com/JF95)
* **Carlos Gallardo Polanco** - *Github profile* - [gpcarlos](https://github.com/gpcarlos)
