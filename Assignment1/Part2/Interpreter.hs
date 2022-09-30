module Interpreter where

import AbsNumbers

eval :: Exp -> Integer
eval (Num n) = n
eval (Plus n m) = (eval n) + (eval m)
eval (Times n m) = (eval n) * (eval m)
eval (Subtract n m) = (eval n) - (eval m) -- 6-3*2 == 0
eval (Negative n) = - (eval n) -- -3*-4 == 12
eval (Divide n m) = (eval n) `div` (eval m) -- 15/4 == 3
eval (Exponent n m) = (eval n) ^ (eval m) -- 2^4/3 == 5
eval (Modulo n m) = (eval n) `mod` (eval m) -- 12%5 == 2
eval (Abs n) = abs (eval n) -- |-3^3| = 27