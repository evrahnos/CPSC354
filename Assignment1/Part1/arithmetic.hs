-- A Virtual Machine (VM) for Arithmetic
-- Copyright: Alexander Kurz and Eleas Vrahnos 2022

-----------------------
-- Data types of the VM
-----------------------

-- Natural numbers
data NN = O | S NN
  deriving (Eq,Show) -- for equality and printing

-- Integers
data II = II NN NN
  deriving Show -- for printing

-- Positive integers (to avoid dividing by 0)
data PP = I | T PP
  deriving (Eq,Show)

-- Rational numbers
data QQ =  QQ II PP
  deriving Show

------------------------
-- Arithmetic on the  VM
------------------------

----------------
-- PP Arithmetic
----------------

-- add positive numbers
addP :: PP -> PP -> PP
addP I m = T m
addP (T n) m = T (addP n m)

-- multiply positive numbers
multP :: PP -> PP -> PP
multP I m = m
multP (T n) m = addP (multP n m) m

-- convert numbers of type PP to numbers of type NN
nn_pp :: PP -> NN
nn_pp I = S O
nn_pp (T n) = S (nn_pp n)

-- convert numbers of type PP to numbers of type II
ii_pp :: PP -> II
ii_pp m = II (nn_pp m) O

----------------
-- NN Arithmetic
----------------

-- add natural numbers
addN :: NN -> NN -> NN
addN O m = m
addN (S n) m = S (addN n m)

-- multiply natural numbers
multN :: NN -> NN -> NN
multN O m = O
multN (S n) m = addN (multN n m) m

-- subtract natural numbers
subN :: NN -> NN -> NN
subN m O = m
subN O n = O
subN (S m) (S n) = subN m n

-- division, eg 13 divided by 5 is 2 
divN :: NN -> PP -> NN
divN m n
    | ((subN m (nn_pp n) == O) && (m /= (nn_pp n))) = O
    | ((subN m (nn_pp n) == O) && (m == (nn_pp n))) = S O
    | otherwise                                     = S (divN (subN m (nn_pp n)) n)

-- remainder, eg 13 modulo by 5 is 3
modN :: NN -> PP -> NN
modN m n = subN m (multN (nn_pp n) (divN m n))

----------------
-- II Arithmetic
----------------

-- Addition: (a-b)+(c-d)=(a+c)-(b+d)
addI :: II -> II -> II
addI (II a b) (II c d) = II (addN a c) (addN b d)

-- Multiplication: (a-b)*(c-d)=(ac+bd)-(ad+bc)
multI :: II -> II -> II
multI (II a b) (II c d) = II (addN (multN a c) (multN b d)) (addN (multN a d) (multN b c))

-- Negation: -(a-b)=(b-a)
negI :: II -> II
negI (II a b) = II b a

-- Convert numbers of type II to numbers of type NN (assuming the integer is positive)
nn_ii :: II -> NN
nn_ii (II m n) = subN m n

-- Equality of integers
instance Eq II where
  (II a b) == (II c d) = (nn_ii (II a b)) == (nn_ii (II c d))

----------------
-- QQ Arithmetic
----------------

-- Addition: (a/b)+(c/d)=(ad+bc)/(bd)
addQ :: QQ -> QQ -> QQ
addQ (QQ a b) (QQ c d) = QQ (addI (multI a (ii_pp d)) (multI (ii_pp b) c)) (multP b d)

-- Multiplication: (a/b)*(c/d)=(ac)/(bd)
multQ :: QQ -> QQ -> QQ
multQ (QQ a b) (QQ c d) = QQ (multI a c) (multP b d)

-- Equality of fractions
instance Eq QQ where
  (QQ a b) == (QQ c d) = (a == c) && (b == d)

----------------
-- Normalisation
----------------

normalizeI :: II -> II
normalizeI (II O n) = II O n
normalizeI (II m O) = II m O
normalizeI (II (S m) (S n)) = normalizeI (II m n)

----------------------------------------------------
-- Converting between VM-numbers and Haskell-numbers
----------------------------------------------------

-- Precondition: Inputs are non-negative
nn_int :: Integer -> NN
nn_int 0 = O
nn_int m = S (nn_int (m-1))

int_nn :: NN->Integer
int_nn O = 0
int_nn (S m) = 1 + (int_nn m)

ii_int :: Integer -> II
ii_int m = (II (nn_int m) O)

int_ii :: II -> Integer
int_ii (II m n) = int_nn (subN m n)

------------------------------
-- Normalisation by Evaluation
------------------------------


----------
-- Testing
----------
main = do
    print $ int_ii (II (S (S (S (S (S O))))) O) -- 5
    print $ int_ii (II O O) -- 0

