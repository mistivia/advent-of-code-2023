-- https://www.codewars.com/kata/5679aa472b8f57fb8c000047

module Codewars.G964.FindEven where

findEvenIndex :: [Int] -> Int
findEvenIndex arr = findEvenIndexImpl [] 0 arr

findEvenIndexImpl left n right
  | right == [] = -1
  | sum left == sum (tail right) = n
  | otherwise = findEvenIndexImpl (left ++ [head right]) (n + 1) (tail right)
