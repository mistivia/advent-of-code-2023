-- https://www.codewars.com/kata/5277c8a221e209d3f6000b56
module Codewars.Kata.Braces where

validBraces :: String -> Bool
validBraces xs = impl 0 0 0 xs where
  impl cnt1 cnt2 cnt3 str =
    if str == [] then
      cnt1 == 0 && cnt2 == 0 && cnt3 == 0
    else let
      x = head str
      xs = tail str
    in
      if cnt1 < 0 || cnt2 < 0 || cnt3 < 0 then
        False
      else if x == '(' then impl (cnt1 + 1) cnt2 cnt3 xs
      else if x == ')' then impl (cnt1 - 1) cnt2 cnt3 xs
      else if x == '[' then impl cnt1 (cnt2 + 1) cnt3 xs
      else if x == ']' then impl cnt1 (cnt2 - 1) cnt3 xs
      else if x == '{' then impl cnt1 cnt2 (cnt3 + 1) xs
      else if x == '}' then impl cnt1 cnt2 (cnt3 - 1) xs
      else False
