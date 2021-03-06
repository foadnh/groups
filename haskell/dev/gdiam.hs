import Control.Monad (liftM2)
import System.Environment (getArgs)
import Closure (view)
import Groups
import Permutation (fromCycle, transposition)

main :: IO ()
main = do
 n <- getArgs >>= readIO . fromHead "5"
 let group = symmetric n
 --let gens = map (transposition 1) [2..n]
 let gens = (fromCycle [1..n] :) $ if n == 1 then [] else [transposition 1 2]
 print $ gdiameter group gens

fromHead :: a -> [a] -> a
fromHead a [] = a
fromHead _ (b:_) = b

-- |Given a group @g@ and a list of generators @gens@, @gdiameter g gens@
-- returns the number of "iterations of the closure algorithm" needed to
-- produce the subgroup that @gens@ generates.  The function assumes that
-- @gens@ contains at least one element other than @gr_id g@.
--
-- This application of graph diameter to groups can be formalized as: Given a
-- generating set $A$, the diameter of (the Cayley graph of) $\gen{A}$ is the
-- smallest $d\in\N$ such that $\bigcup_{i=0}^d A_i = \gen{A}$ (or,
-- equivalently, such that $\bigcup_{i=0}^d A_i = \bigcup_{i=0}^{d+1} A_i$)
-- where $A_0 = \{1\}$ and $A_{i+1} = A_iA$.
--
-- Note that the diameter of a Cayley graph equals the eccentricity of the
-- identity.

gdiameter :: Ord a => Group a -> [a] -> Int
gdiameter g gens = gdiam 0 ([gid g], gtrivial g)
 where gdiam i ([], _) = i-1
       gdiam i (new, seen) = gdiam (i+1) $ view (liftM2 (goper g) new gens) seen

{-
Diameters thus calculated so far:
 - Let Σ_n = {(1 i) : i∈[2..n]}; then ⟨Σ_n⟩ = S_n
  - δ(Σ_1) = δ(∅) = 0
  - δ(Σ_2) = 1
  - δ(Σ_3) = 3
  - δ(Σ_4) = 4
  - δ(Σ_5) = 6
  - δ(Σ_6) = 7
  - δ(Σ_7) = 9
  - δ(Σ_8) = 10
  - δ(Σ_9) = 12
 - Let T_n = {(1 2), (1 2 ... n)}; then ⟨T_n⟩ = S_n
  - δ(T_1) = δ({1}) = 0
  - δ(T_2) = 1
  - δ(T_3) = 2
  - δ(T_4) = 6
  - δ(T_5) = 11
  - δ(T_6) = 18
  - δ(T_7) = 25
  - δ(T_8) = 35
  - δ(T_9) = 45
  - {δ(T_i)}_{i∈ℤ⁺} is A039745 in OEIS
-}
