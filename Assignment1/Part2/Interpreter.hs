module Interpreter where

import AbsNumbers

eval :: Exp -> Integer
eval (Num n) = n
eval (Plus n m) = (eval n) + (eval m)
eval (Times n m) = (eval n) * (eval m)
eval (Subtract n m) = (eval n) - (eval m) -- 6-3*2 == 0
eval (Negative n) = - (eval n) -- -3*-4 == 12