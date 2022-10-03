# Steps to Generate Lambda Calculus Parser

This lambda calculus parser was generated using the given file `LambdaNat0.cf` as the context-free grammar. The first step to generating the parser would be:

    bnfc -m -haskell numbers.cf

This generates many files, but the main one for generating the parser will be ``AbsLambdaNat.hs``. These files will be compiled and made into a parser through the command:

    make

The parser is generated as `TestLambdaNat`. This can be used to generate abstract syntax trees with:

    echo "<expression here>" | ./TestLambdaNat