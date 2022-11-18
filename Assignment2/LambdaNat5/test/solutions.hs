-- PROGRAMS WITH IMPLEMENTATIONS AND TEST CASES 


-- is_empty: is_empty l evaluates to 1/True  if l is the empty list and to 0/False if l is not empty.
is_empty :: [a] -> Bool
is_empty [] = True
is_empty _ = False

-- fib: fib n evaluates to the n-th element of the Fibonacci sequence (zero-indexed) (0,1,1,2,3,5,8,13,...)
fib :: Int -> Int
fib 0 = 0
fib 1 = 1
fib n = fib (n-1) + fib (n-2)
    
-- length: length l evaluates to the length of a list l (changed name to lengthfunc because of in-built function length)
lengthfunc :: [a] -> Int
lengthfunc [] = 0
lengthfunc (x:xs) = 1 + lengthfunc xs

-- even: even l evaluates to 1/True if l is a list of even length and evaluates to 0/False if l is not of even length (changed name to evenfunc because of in-built function even)
evenfunc :: [a] -> Bool
evenfunc [] = True
evenfunc (x:[]) = False
evenfunc (x:y:xs) = evenfunc (xs)

-- append: append xs ys appends a list ys to another list xs
append [] ys = ys
append (x:xs) ys = x : append xs ys

-- reverse: reverse l reverses a list l (changed name to reversefunc because of in-built function reverse)
reversefunc [] = []
reversefunc (x:xs) = append (reversefunc (xs)) [x]

-- weave: weave ns ms weaves together to lists of integers, respecting their order
weave :: [Int] -> [Int] -> [Int]
weave [] [] = []
weave (x:xs) [] = x : weave xs []
weave [] (y:ys) = y : weave [] ys
weave (x:xs) (y:ys)
    | x<y = x : (weave xs (y:ys))
    | otherwise = y : (weave (x:xs) ys)


main :: IO ()
main = do
    
    putStrLn "FUNCTION: is_empty"
    print(is_empty ["a"])   -- testing: is_empty a:#        False
    print(is_empty [])      -- testing: is_empty a:#        True

    putStrLn "\nFUNCTION: fib"
    print(fib 6)            -- testing: fib 6               8
    print(fib 0)            -- testing: fib 0               0
    print(fib 1)            -- testing: fib 1               1

    putStrLn "\nFUNCTION: length"
    print(lengthfunc ["a", "b", "c"])       -- testing: length a:b:c:#          3
    print(lengthfunc [])                    -- testing: length #                0
    print(lengthfunc ["a"])                 -- testing: length a:#              1

    putStrLn "\nFUNCTION: even"
    print(evenfunc ["a1", "a2", "a3", "a4"])        -- testing: a1:a2:a3:a4:#       True
    print(evenfunc ["a1", "a2", "a3", "a4", "a5"])  -- testing: a1:a2:a3:a4:a5:#    False
    print(evenfunc [])                              -- testing: #                   True
    print(evenfunc ["a1"])                          -- testing: a1:#                False
    print(evenfunc ["a1", "a2"])                    -- testing: a1:a2:#             True

    putStrLn "\nFUNCTION: reverse"
    print(reversefunc ["a", "b", "c"])          -- testing: reverse a:b:c:#          ["c", "b", "a"]
    print(reversefunc [] :: [Int])              -- testing: reverse #                []
    print(reversefunc ["a"])                    -- testing: reverse a:#              ["a"]

    putStrLn "\nFUNCTION: weave"
    print(weave [0,1,4] [2,3,5])            -- testing: weave (0:1:4:#) (2:3:5:#)           [0,1,2,3,4,5]  
    print(weave [] [])                      -- testing: weave # #                           []
    print(weave [1] [])                     -- testing: weave 1:# #                         [1]
    print(weave [1,2] [])                   -- testing: weave 1:2:# #                       [1,2]
    print(weave [] [1])                     -- testing: weave # 1:#                         [1]
    print(weave [] [1,2])                   -- testing: weave # 1:2:#                       [1,2]
    print(weave [1,2,3] [1,3,4])            -- testing: weave 1:2:3:# 1:3:4:#               [1,1,2,3,3,4]

