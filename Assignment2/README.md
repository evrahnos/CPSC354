# Critical Appraisal

## General Information

**Group Members:** Eleas Vrahnos

**Date of Submission:** 
- November 6, 2022 (Part 1)
- November 18, 2022 (Part 2)

**Completed Contents of Assignment 1:**
- `LambdaNat0`
- `LambdaNat1`
- `LambdaNat2`
- `LambdaNat3`
- `LambdaNat4`
- `LambdaNat5`

**Uncompleted Contents of Assignment 1:** None

**Known Bugs/Problems:** None

## Overall Notes and Thoughts

This assignment built on top of the knowledge gained from Assignment 1, with this assignment now featuring more functions, implementing conditionals and recursion, and lists. Naturally, this comes with a lot more pattern matching and test cases. The test cases for the functions implemented in this assignment were based around the provided test cases and edge cases. For example, the majority of the functions required testing on an empty list (using `ENil`/`#`) to make sure it would not throw any errors.

Throughout this project, I learned that pattern matching has some very noticeable advantages and disadvntages to it. An advantage is that it is very intuitive, and all the interpreter needs to do is to match a given case with the cases it covers, making it very straightforward. This makes recursion very intuitive as well. A disadvantage is the lack of meaning behind any names given. For example, `ECons` describes a list, but this is not shown in the name nor values in the parser. All we know is that it contains a first part (arbitrarily named `head`) and a second part (arbitrarily named `tail`), and it is up to us to decipher what real-world functionality this implementation holds.

An interesting observation I have noticed is the inability to parse `#:#`, while `(#):#` is parsable. If I had to give an educated guess, I would say this is due to the parentheses treating the first `#` as a separate list, therefore satisfying the grammar for the second `#`, the grammar being `<list>:#`. I don't believe the grammar needs to be changed for this as `ENil` is well defined to be the `EndOfList`, but it does raise some possibilities of reduction. For example, `(<list>:#):#` may certainly appear in a calculation, so reducing it down to `<list>:#` in some capacity may make interpretation of the list more intuitive.

Another interesting question I had was in regards to the practicality of including the implemented functions (`is_empty`, `fib`, etc.) in the parser/interpreter directly. This may be impractical due to the complex nature of some of these functions, but I was wondering of the deeper advantages and disadvantages of such a design choice. A function already exists in this state (`ELE`/`less_equal`), so what makes this different than the other implemented functions? *Is* there a difference?

## Further Analysis

### On the use of multiple test cases

In order to support the functionality of multiple test cases when testing functions, the operator `;;` was used to do so. To support multiple test cases, a change in the parser and interpreter was made to make this possible.

In the parser, the following line was added:
```
separator Exp ";;" ;
```
This line defines the syntax for a separator, which is pre-defined in BNFC as a statement that terminates the element in the execution list. In other words, a separator defines when a command ends.

In the interpreter, the following lines were adjusted:
```
execCBN :: Program -> [Exp]
execCBN (Prog []) = []
execCBN (Prog (e:es)) = (evalCBN e):(execCBN (Prog es))
```
These lines actually execute the code within the interpreter, with the adjustment being the expression now being a list of expressions. The executing command is now a recursive function, with the list of expressions being executed one by one. The `;;` separator therefore defines how the expressions are split up into list elements that are iterated through here.

### On the differences between `LambdaNat5` and the Calculator

For `LambdaNat5`, using arithmetic to define arithmetic operators (such as `EPlus`) is seen to be no longer feasible by itself. This is mainly to do with the purpose of the program itself. The original calculator was only ever meant to do operations on integers, and thus using arithmetic (which was call by value in this case) was acceptable. 

However, `LambdaNat5` introduces lambda calculus and more data types than integers, such as lists. These can also all combine to make more complicated expressions. Therefore, `EPlus` must now support the addition of more complicated expressions, meaning that there are cases where the operands are integers and cases where they are not. Operations are now mainly call by name, since the operations do not or cannot be evaluated before inserting into the expression, due to more data types besides integers being present.

### On the differences between `LambdaNat5` and Haskell

`LambdaNat5` has already proven to have a lot of functionality, but it still stands inferior compared to the full functional programming language of Haskell. In my opinion, one big reason this is the case is expression versatility.

In other words, `LambdaNat5` conformity to exact syntax holds it back from being as versatile as it could be. For example, parentheses may make or break an operation, but Haskell is able to infer more accurately where parentheses are need and where they are not needed. This is a problem I had when trying to implement the `reverse` function, as defining (or not defining) parentheses made implementation more difficult, due to `LambdaNat5` thinking that parentheses were used for forming lists, rather than order of operations. To get one step closer to a more powerful programming language, this kind of adaptability can be implemented in some way.

### On the invariances of `weave` and its relation to `sort`

The function `weave` satisfies the invariant "the output-list is sorted if the input-lists are sorted". This is true because of the nature of the function. It compares the sorted input lists by their first values. Since the input lists are already sorted and the `weave` function takes away from these lists following the `ELE` rule, the resulting list will naturally be sorted.

This can be related to the `sort` function itself. One way this can be understood is breaking down an input list into single elements. This is allowed due to another invariance of `weave`, which states that the following equation is satisfied:
```
length (weave ns ms) = (length ns) + (length ms)
```
This means that separating a list will not change the combined lengths of the lists. If a list was to be broken down to its single elements, the lists are guaranteed to be, by definition, sorted (it is the only element, which compares to itself). Therefore, using `weave` on all of these single-element lists will guarantee the final combined list to be sorted as well, due to the first invariance.

One well-known kind of sorting algorithm, the merge sort, describes this concept exactly, which is summarized in the example image below:

![](https://www.programiz.com/sites/tutorial2program/files/merge-sort-example_0.png)

