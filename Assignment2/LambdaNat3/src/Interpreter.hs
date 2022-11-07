module Interpreter ( execCBN ) where

import AbsLambdaNat 
import ErrM
import PrintLambdaNat

execCBN :: Program -> Exp  
execCBN (Prog e) = evalCBN e
evalCBN :: Exp -> Exp  
evalCBN (EApp e1 e2) = case (evalCBN e1) of
    (EAbs i e3) -> evalCBN (subst i e2 e3)
    e3 -> EApp e3 e2
----------------------------------------------------
--- YOUR CODE goes here for extending the interpreter
----------------------------------------------------
evalCBN ENat0 = ENat0 
evalCBN (ENatS e1) = ENatS (evalCBN e1)
evalCBN (EIf e1 e2 e3 e4) | e1 == e2 = evalCBN e3
                          | otherwise = evalCBN e4
evalCBN x = x -- this is a catch all clause, currently only for variables, must be the last clause of the eval function

-- a quick and dirty way of getting fresh names. Rather inefficient for big terms...
fresh_aux :: Exp -> String
fresh_aux (EVar (Id i)) = i ++ "0"
fresh_aux (EApp e1 e2) = fresh_aux e1 ++ fresh_aux e2
fresh_aux (EAbs (Id i) e) = i ++ fresh_aux e
fresh_aux _ = "0"

fresh = Id . fresh_aux -- for Id see AbsLamdaNat.hs

-- subst implements the beta rule
-- (\x.e)e' reduces to subst x e' e
subst :: Id -> Exp -> Exp -> Exp
subst id s (EVar id1) | id == id1 = s
                      | otherwise = EVar id1
subst id s (EApp e1 e2) = EApp (subst id s e1) (subst id s e2)
subst id s (EAbs id1 e1) = 
    let f = fresh (EAbs id1 e1)
        e2 = subst id1 (EVar f) e1 in 
        EAbs f (subst id s e2)
----------------------------------------------------------------
--- YOUR CODE goes here if subst needs to be extended as well
----------------------------------------------------------------
subst id e1 ENat0 = ENat0 
subst id e1 (ENatS e2) = ENatS (subst id e1 e2)
subst id (EIf e1 e2 e3 e4) e | e1 == e2 = subst id e3 e
                             | otherwise = subst id e4 e

-- evalCBN (EApp (EAbs (Id "x") (EVar (Id "x"))) (EIf ENat0 ENat0 ENat0 (ENatS ENat0)))
-- evalCBN (subst (Id "x") (EIf ENat0 ENat0 ENat0 (ENatS ENat0)) (EVar (Id "x")))
-- evalCBN (subst (Id "x") (ENat0) (EVar (Id "x")))
-- evalCBN (ENat0)
-- ENat0
