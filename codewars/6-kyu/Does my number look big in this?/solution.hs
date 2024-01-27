-- https://www.codewars.com/kata/5287e858c6b5a9678200083c

module Narcissistic where

splitNum n = reverse $ impl n
  where
  impl n
    | n < 10 = [n]
    | otherwise = (n `mod` 10):(impl (n `div` 10))

narcissistic :: Integral n => n -> Bool
narcissistic n
  | (sum $ map (^ (length splited)) splited) == n = True
  | otherwise = False
  where
    splited = splitNum n

