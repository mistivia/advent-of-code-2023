-- https://www.codewars.com/kata/54b42f9314d9229fd6000d9c

module Dups where

import Data.Char

count s c
  | s == [] = 0
  | c == (head s) = 1 + count (tail s) c
  | otherwise = count (tail s) c

convert s c
  | count s c > 1 = ')'
  | otherwise = '('

duplicateEncode :: String -> String
duplicateEncode s = map (convert ls) ls
  where ls = map toLower s
