import Groups
import Permutation (showCycles)

group = symmetric' 5
--group = alternating' 5

main = mapM_ (\s -> putStrLn $ show (g'index group s) ++ '\t' : showCycles s)
 $ g'elems group
