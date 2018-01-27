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
  make exe
  ```

  The other option is:

  ```bash
  cat CircuitName.circuit | ./analyzer
  ```

## Documentation
We offer a little guide and a report to those who want to know a little bit more about the design of this language, its building process or its syntax. Also, if you want to compile the tex file to generate the document, just type in your terminal:

```bash
  make doc
```

## Authors

* **Juan Francisco Cabrera Sánchez** - *Github profile* - [JF95](https://github.com/JF95)
* **Carlos Gallardo Polanco** - *Github profile* - [gpcarlos95](https://github.com/gpcarlos95)
