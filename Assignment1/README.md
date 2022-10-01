# Critical Appraisal

## General Information

**Group Members:** Eleas Vrahnos

**Date of Submission:** September 30, 2022

**Completed Contents of Assignment 1:**
- `Part1 / arithmetic.hs`
- `Part2 / Calculator.hs`
- `Part2 / Interpreter.hs`
- `Part2 / numbers.cf`

**Uncompleted Contents of Assignment 1:** None

**Known Bugs/Problems:** None  

## Overall Notes and Thoughts
This assignment has taught me a lot about how much code and planning goes into a simple calculator, through parsers, interpreters, and grammar. It also helped me getting used to building a project from scratch, with frequent commits and testing being of vital importance. For each function and case implemented, it was tested individually with every other operation in the syntax tree, which helped confirm the order of operations and functionality. For example, testing the `Exponent` case with every other existing case ensured to me that any exponents within the input string would be evaluated first, producing a correct answer and syntax tree.

I learned that a project like this focuses a lot on pattern matching and recursion, and slowly building from an abstract idea to a concrete syntax is what makes this calculator possible. Even though pattern matching is a relatively simple concept, combining it with recursion makes something powerful. Being able to define a base case and a recursive case allows for endless input possibilities for a single function, and that's what makes this calculator so versatile.

An interesting observation I've made is how much it helps to define types for the arithmetic functions that were made. For example, defining a difference between natural numbers and positive numbers made preventing errors easier for division, not allowing a calculation to divide by 0. This distinction also helped with defining fractions, as doing operations on fractions would be impossible with denominators of 0. Explicitly defining types makes parsing easier, and it personally helped me conceptualize what kind of numbers we wanted to use for each function. A lot of research was done to learn of the different type classes involving numbers, but it taught me the purpose of each one and why they exist.

## Part 1 Analysis
The following analysis will demonstrate 5 selected functions from `arithmetic.hs` and their functionality, using test inputs and equational reasoning.

```haskell
-- subN function, subtracts two natural numbers
subN :: NN -> NN -> NN
subN m O = m
subN O n = O
subN (S m) (S n) = subN m n

-- Equational reasoning
subN (S (S (S O))) (S O) = -- 3 - 1
    subN (S (S O)) (O) =
    (S (S O))              -- 2
```

```haskell
-- addP function, adds two positive numbers
addP :: PP -> PP -> PP
addP I m = T m
addP (T n) m = T (addP n m)

-- Equational reasoning
addP (T (T I)) (T I) =      -- 3 + 2
    T (addP (T I) (T I)) =
    T (T (addP I (T I))) =
    T (T (T (T I)))         -- 5
```

```haskell
-- multP function, multiplies two positive numbers
multP :: PP -> PP -> PP
multP I m = m
multP (T n) m = addP (multP n m) m

-- Equational reasoning
multP (T I) (T (T I)) =                  -- 2 * 3
    addP (multP I (T (T I))) (T (T I)) =
    addP (T (T I)) (T (T I)) =
    T (addP (T I) (T (T I))) =
    T (T (addP I (T (T I)))) =
    T (T (T (T (T I))))                  -- 6
```

```haskell
-- addI function, adds two integers
addI :: II -> II -> II
addI (II a b) (II c d) = II (addN a c) (addN b d)

-- Equational reasoning
addI (II (S O) (S (S O))) (II (S O) O) =       -- -1 + 1, or (1-2) + (1-0)
    II (addN (S O) (S O)) (addN (S (S O)) O) =
    II (S (addN O (S O))) (addN (S (S O)) O) =
    II (S (S O)) (addN (S (S O)) O) =
    II (S (S O)) (S (addN (S O) O)) =
    II (S (S O)) (S (S (addN O O))) =
    II (S (S O)) (S (S O))                     -- 0, or (2-2)
```

```haskell
-- normalizeI function, normalizes an integer to its simplest form
normalizeI :: II -> II
normalizeI (II O n) = II O n
normalizeI (II m O) = II m O
normalizeI (II (S m) (S n)) = normalizeI (II m n)

-- Equational reasoning
normalizeI (II (S (S (S O))) (S (S O))) = -- 1, or 3-2
    normalizeI (II (S (S O)) (S O)) =
    normalizeI (II (S O) O) =
    II (S O) O                            -- 1, or 1-0
```

## Part 2 Analysis
In order to develop this calculator, I had to decide on an order of operations for my 8 operations of choice. 

To determine this, I wanted to start with a baseline of "PEMDAS", meaning I wanted to evaluate exponents before multiplication/division, which is before addition/subtraction. 

For my negative function, I took advantage of the fact that in this calculator example, this would operate on one integer, and not a bigger expression. Therefore, I put this operation on the highest level before exponent, so that the negative sign can be attached to the number. This was done with attaching the sign to `Exp3`, forcing it be after `Exponent`'s `Exp2` and `Exp3`.

For my absolute value function, I wanted to implement it similar to how parentheses would operate. Therefore, everything inside the absolute value signs would be evaluted before the actual function was applied. Therefore, this operation would also be before exponents, but using `Exp` instead of `Exp3`, as there could be a bigger expression within.

Finally, for my modulo function, I decided to put this on the same level as multiplication and division. This is because modulo is directly connected with division, so it made sense to me to treat them as similar functions and on the same level. To show this, I used `Exp1` and `Exp2` for all three of these functions, putting it before addition/subtraction (which use `Exp` and `Exp1`), but after the rest of the functions.
